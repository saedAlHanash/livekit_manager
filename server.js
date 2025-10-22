// server.js
const express = require("express");
const { AccessToken, TrackSource } = require("livekit-server-sdk");
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const PORT = process.env.PORT || 5000;
const API_KEY = process.env.LIVEKIT_API_KEY;
const API_SECRET = process.env.LIVEKIT_API_SECRET;

if (!API_KEY || !API_SECRET) {
  console.error("LIVEKIT_API_KEY / LIVEKIT_API_SECRET must be set in env");
  process.exit(1);
}

const app = express();
app.use(cors());
app.use(express.json({ limit: "1mb" }));

// Default participant-level permissions
const DEFAULT_PARTICIPANT_PERMISSIONS = {
  canSubscribe: true,
  canPublish: true,
  canPublishData: true,
  hidden: false,
  canUpdateMetadata: false,
  recorder: false,
  // this will be normalized later to TrackSource enums
  canPublishSources: [
    "unknown",
    "camera",
    "microphone",
    "screen_share",
    "screen_share_audio",
  ],
};

// Default grants
const DEFAULT_GRANTS = {
  roomJoin: true,
  canPublish: true,
  canSubscribe: true,
  canPublishData: true,
  roomAdmin: false,
  roomList: false,
  participantPermissions: { ...DEFAULT_PARTICIPANT_PERMISSIONS },
  room: undefined,
};

function normalizeSourcesToEnum(srcs) {
  if (!srcs) return [];
  if (!Array.isArray(srcs)) srcs = [srcs];

  const result = [];

  for (let s of srcs) {
    let val = TrackSource.UNKNOWN;

    if (typeof s === "string") {
      const key = s.trim().toLowerCase().replace(/[-\s]/g, "_");
      switch (key) {
        case "camera":
          val = TrackSource.CAMERA;
          break;
        case "microphone":
        case "mic":
          val = TrackSource.MICROPHONE;
          break;
        case "screen":
        case "screenshare":
        case "screen_share":
          val = TrackSource.SCREEN_SHARE;
          break;
        case "screenshare_audio":
        case "screen_share_audio":
          val = TrackSource.SCREEN_SHARE_AUDIO;
          break;
        case "unknown":
        default:
          val = TrackSource.UNKNOWN;
          break;
      }
    }

    if (!result.includes(val)) result.push(val);
  }

  console.log("✅ Normalized canPublishSources:", result);
  return result;
}

app.post("/get-token", async (req, res) => {
  try {
    const users = Array.isArray(req.body) ? req.body : [req.body];

    if (!users || users.length === 0) {
      return res.status(400).json({ error: "Body must be a non-empty array" });
    }

    const results = [];

    for (const input of users) {
      const genIdentity = () =>
        `guest_${Math.random().toString(36).slice(2, 9)}`;

      const defaults = {
        room_name: null,
        identity: genIdentity(),
        display_name: null,
        role: "participant",
        attributes: {},
        ttl: null,
        metadata: "",
        grants: null,
        participantPermissions: null,
      };

      const user = { ...defaults, ...(input || {}) };

      // required fields
      if (!user.room_name || !user.identity) {
        results.push({ error: "room_name and identity are required" });
        continue;
      }

      // merge grants and permissions
      const grants = { ...DEFAULT_GRANTS, ...(user.grants || {}) };
      grants.room = user.room_name;

      const pp = {
        ...DEFAULT_PARTICIPANT_PERMISSIONS,
        ...(user.participantPermissions || grants.participantPermissions || {}),
      };

      // normalize to TrackSource enums (important: LiveKit expects TrackSource[] here)
      // We keep the field name as canPublishSources but make sure it's enum array
      pp.canPublishSources = normalizeSourcesToEnum(pp.canPublishSources);

      // elevate admin
      if (user.role === "admin") {
        grants.roomAdmin = true;
        grants.canUpdateOwnMetadata = true;
        grants.roomList = true;
        pp.canUpdateMetadata = true;
      }

      // normalize attributes
      const attributesNormalized = {};
      if (user.attributes && typeof user.attributes === "object") {
        for (const [k, v] of Object.entries(user.attributes)) {
          attributesNormalized[k] =
            typeof v === "string" ? v : JSON.stringify(v);
        }
      }

      const metadataStr =
        user.metadata === null || user.metadata === undefined
          ? ""
          : typeof user.metadata === "string"
          ? user.metadata
          : JSON.stringify(user.metadata);

      // build token
      const at = new AccessToken(API_KEY, API_SECRET, {
        identity: user.identity,
        name: user.display_name || user.identity,
        metadata: metadataStr,
        ttl: Number.isInteger(user.ttl) ? user.ttl : undefined,
      });

      if (Object.keys(attributesNormalized).length > 0) {
        at.attributes = attributesNormalized;
      }

      // --- IMPORTANT: pass TrackSource[] (enums/numbers) to both top-level and participantPermissions
      const videoGrant = {
        roomJoin: !!grants.roomJoin,
        room: grants.room,
        canPublish: !!grants.canPublish,
        canSubscribe: !!grants.canSubscribe,
        canPublishData: !!grants.canPublishData,
        roomAdmin: !!grants.roomAdmin,
        roomList: !!grants.roomList,
        canUpdateMetadata: !!pp.canUpdateMetadata,
        canPublishSources: pp.canPublishSources,
        hidden: !!pp.hidden,
        recorder: !!pp.recorder,
        // participantPermissions: {
        //   can_subscribe: !!pp.canSubscribe,
        //   can_publish: !!pp.canPublish,
        //   can_publish_data: !!pp.canPublishData,
        //   // pass the same enum array here as well
        //   can_publish_sources: pp.canPublishSources,
        //   can_update_metadata: !!pp.canUpdateMetadata,
        //   hidden: !!pp.hidden,
        //   recorder: !!pp.recorder,
        // },
      };

      // debug: log the grant sources types (optional, remove in prod)
      // console.log("pp.canPublishSources (as enums):", pp.canPublishSources);

      at.addGrant(videoGrant);
      const token = await at.toJwt();

      results.push({
        token,
        identity: user.identity,
        display_name: user.display_name || user.identity,
      });
    }

    return res.json(results);
  } catch (err) {
    console.error("token error", err);
    return res
      .status(500)
      .json({ error: "internal_error", detail: String(err) });
  }
});

app.listen(PORT, () =>
  console.log(`✅ LiveKit Token server running on port ${PORT}`)
);
