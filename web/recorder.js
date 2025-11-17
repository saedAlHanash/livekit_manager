let mediaRecorder;
let recordedChunks = [];

function startRecording() {
  return new Promise(async (resolve, reject) => {
    try {
      const stream = await navigator.mediaDevices.getDisplayMedia({
        video: true,
        audio: true
      });
      mediaRecorder = new MediaRecorder(stream);
      recordedChunks = [];

      mediaRecorder.ondataavailable = e => {
        if (e.data.size > 0) recordedChunks.push(e.data);
      };

      mediaRecorder.start();
      resolve(true); // Promise حقيقية
    } catch (err) {
      reject(err);
    }
  });
}

function stopRecording() {
  return new Promise(resolve => {
    mediaRecorder.onstop = () => {
      const blob = new Blob(recordedChunks, { type: 'video/webm' });
      const url = URL.createObjectURL(blob);

      // تحميل تلقائي
      const a = document.createElement('a');
      a.href = url;
      a.download = 'recorded_video.webm';
      a.click();

      resolve(url);
    };
    mediaRecorder.stop();
  });
}
