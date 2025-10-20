// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Invalid email`
  String get wrongEmail {
    return Intl.message(
      'Invalid email',
      name: 'wrongEmail',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Choosing`
  String get choosing {
    return Intl.message('Choosing', name: 'choosing', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Educational Grade`
  String get educationalGrade {
    return Intl.message(
      'Educational Grade',
      name: 'educationalGrade',
      desc: '',
      args: [],
    );
  }

  /// `Mail`
  String get mail {
    return Intl.message('Mail', name: 'mail', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Favorites`
  String get fav {
    return Intl.message('Favorites', name: 'fav', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrder {
    return Intl.message('My Orders', name: 'myOrder', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please create an account`
  String get pleasCreateAccount {
    return Intl.message(
      'Please create an account',
      name: 'pleasCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message('Username', name: 'userName', desc: '', args: []);
  }

  /// `Home Address`
  String get homeAddress {
    return Intl.message(
      'Home Address',
      name: 'homeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get rePassword {
    return Intl.message(
      'Confirm Password',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Course`
  String get course {
    return Intl.message('Course', name: 'course', desc: '', args: []);
  }

  /// `Teacher`
  String get teacher {
    return Intl.message('Teacher', name: 'teacher', desc: '', args: []);
  }

  /// `Session`
  String get session {
    return Intl.message('Session', name: 'session', desc: '', args: []);
  }

  /// `Lecture Type`
  String get lectureType {
    return Intl.message(
      'Lecture Type',
      name: 'lectureType',
      desc: '',
      args: [],
    );
  }

  /// `Current Count`
  String get currentCount {
    return Intl.message(
      'Current Count',
      name: 'currentCount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Please check your internet connection`
  String get noInternet {
    return Intl.message(
      'Please check your internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Name field is required`
  String get nameEmpty {
    return Intl.message(
      'Name field is required',
      name: 'nameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Phone number field is required`
  String get phoneNumberEmpty {
    return Intl.message(
      'Phone number field is required',
      name: 'phoneNumberEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email field is required`
  String get emailEmpty {
    return Intl.message(
      'Email field is required',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password field is required`
  String get passwordEmpty {
    return Intl.message(
      'Password field is required',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match`
  String get passwordNotMatch {
    return Intl.message(
      'Password does not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgetPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueTo {
    return Intl.message('Continue', name: 'continueTo', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Confirmation Code`
  String get confirmCode {
    return Intl.message(
      'Enter Confirmation Code',
      name: 'confirmCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation code sent to email: `
  String get codeSentToEmail {
    return Intl.message(
      'Confirmation code sent to email: ',
      name: 'codeSentToEmail',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Terms of Use and Privacy Policy`
  String get policy {
    return Intl.message(
      'Terms of Use and Privacy Policy',
      name: 'policy',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get policyJust {
    return Intl.message(
      'Privacy Policy',
      name: 'policyJust',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Contact Us`
  String get contact {
    return Intl.message('Contact Us', name: 'contact', desc: '', args: []);
  }

  /// `Change Name`
  String get changeName {
    return Intl.message('Change Name', name: 'changeName', desc: '', args: []);
  }

  /// `Change Phone Number`
  String get changePhone {
    return Intl.message(
      'Change Phone Number',
      name: 'changePhone',
      desc: '',
      args: [],
    );
  }

  /// `Change Address`
  String get changeAddress {
    return Intl.message(
      'Change Address',
      name: 'changeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePass {
    return Intl.message(
      'Change Password',
      name: 'changePass',
      desc: '',
      args: [],
    );
  }

  /// `Phone number cannot be changed`
  String get phoneNumberCanNotBeChange {
    return Intl.message(
      'Phone number cannot be changed',
      name: 'phoneNumberCanNotBeChange',
      desc: '',
      args: [],
    );
  }

  /// `Continue Sign Up`
  String get continueSignUp {
    return Intl.message(
      'Continue Sign Up',
      name: 'continueSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get wrongPhone {
    return Intl.message(
      'Invalid phone number',
      name: 'wrongPhone',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Hello there, sign in to continue`
  String get signInToContinue {
    return Intl.message(
      'Hello there, sign in to continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message('Remember Me', name: 'rememberMe', desc: '', args: []);
  }

  /// `Don't Have An Account?`
  String get doNotHaveAnAccount {
    return Intl.message(
      'Don\'t Have An Account?',
      name: 'doNotHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In With Social Networks:`
  String get signInWithSocial {
    return Intl.message(
      'Sign In With Social Networks:',
      name: 'signInWithSocial',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `birthday`
  String get birthday {
    return Intl.message('birthday', name: 'birthday', desc: '', args: []);
  }

  /// `The Phone Number Is 11 Digits`
  String get need11 {
    return Intl.message(
      'The Phone Number Is 11 Digits',
      name: 'need11',
      desc: '',
      args: [],
    );
  }

  /// `The Password Is More Than 8 Letters And Numbers`
  String get need8 {
    return Intl.message(
      'The Password Is More Than 8 Letters And Numbers',
      name: 'need8',
      desc: '',
      args: [],
    );
  }

  /// `confirm password`
  String get confirmPassword {
    return Intl.message(
      'confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already Have An Account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already Have An Account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In.`
  String get sgnIn {
    return Intl.message('Sign In.', name: 'sgnIn', desc: '', args: []);
  }

  /// `Please Choose How You Would Like To Send The Verification Code`
  String get confirmMethod {
    return Intl.message(
      'Please Choose How You Would Like To Send The Verification Code',
      name: 'confirmMethod',
      desc: '',
      args: [],
    );
  }

  /// `Phone Call`
  String get phoneCall {
    return Intl.message('Phone Call', name: 'phoneCall', desc: '', args: []);
  }

  /// `Phone SMS`
  String get phoneSms {
    return Intl.message('Phone SMS', name: 'phoneSms', desc: '', args: []);
  }

  /// `Enter Your OTP Code Here.`
  String get enterOTP {
    return Intl.message(
      'Enter Your OTP Code Here.',
      name: 'enterOTP',
      desc: '',
      args: [],
    );
  }

  /// `Didn't Receive The OTP?`
  String get didNotReceiveOTP {
    return Intl.message(
      'Didn\'t Receive The OTP?',
      name: 'didNotReceiveOTP',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `verify`
  String get verify {
    return Intl.message('verify', name: 'verify', desc: '', args: []);
  }

  /// `Account Created!`
  String get accountCreated {
    return Intl.message(
      'Account Created!',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Your Account Had Been Created`
  String get haveBeenCreated {
    return Intl.message(
      'Your Account Had Been Created',
      name: 'haveBeenCreated',
      desc: '',
      args: [],
    );
  }

  /// `Successfully.`
  String get successfully {
    return Intl.message(
      'Successfully.',
      name: 'successfully',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Number Phone`
  String get numberPhone {
    return Intl.message(
      'Number Phone',
      name: 'numberPhone',
      desc: '',
      args: [],
    );
  }

  /// `Your Password Has\nBeen Reset!`
  String get passwordReset {
    return Intl.message(
      'Your Password Has\nBeen Reset!',
      name: 'passwordReset',
      desc: '',
      args: [],
    );
  }

  /// `save change`
  String get saveChange {
    return Intl.message('save change', name: 'saveChange', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your Address`
  String get yourAddress {
    return Intl.message(
      'Your Address',
      name: 'yourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Your Phone`
  String get yourPhone {
    return Intl.message('Your Phone', name: 'yourPhone', desc: '', args: []);
  }

  /// `Your Name`
  String get yourName {
    return Intl.message('Your Name', name: 'yourName', desc: '', args: []);
  }

  /// `Your Email`
  String get yourEmail {
    return Intl.message('Your Email', name: 'yourEmail', desc: '', args: []);
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `first name`
  String get firstName {
    return Intl.message('first name', name: 'firstName', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Use Current Location`
  String get useCurrentLocation {
    return Intl.message(
      'Use Current Location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Registered Before`
  String get registeredBefore {
    return Intl.message(
      'Registered Before',
      name: 'registeredBefore',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get changeEmail {
    return Intl.message(
      'Change Email',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `My Info`
  String get myInfo {
    return Intl.message('My Info', name: 'myInfo', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `WishList`
  String get wishList {
    return Intl.message('WishList', name: 'wishList', desc: '', args: []);
  }

  /// `F.A.q`
  String get faq {
    return Intl.message('F.A.q', name: 'faq', desc: '', args: []);
  }

  /// `Terms And Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms And Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Currency`
  String get currency {
    return Intl.message('Currency', name: 'currency', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Done resend code`
  String get done_resend_code {
    return Intl.message(
      'Done resend code',
      name: 'done_resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Search In All`
  String get search_In_All {
    return Intl.message(
      'Search In All',
      name: 'search_In_All',
      desc: '',
      args: [],
    );
  }

  /// `Flash Deal`
  String get flash_deal {
    return Intl.message('Flash Deal', name: 'flash_deal', desc: '', args: []);
  }

  /// `See all`
  String get see_all {
    return Intl.message('See all', name: 'see_all', desc: '', args: []);
  }

  /// `Offer`
  String get offer {
    return Intl.message('Offer', name: 'offer', desc: '', args: []);
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `seconds`
  String get seconds {
    return Intl.message('seconds', name: 'seconds', desc: '', args: []);
  }

  /// `Min`
  String get min {
    return Intl.message('Min', name: 'min', desc: '', args: []);
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Sizes`
  String get sizes {
    return Intl.message('Sizes', name: 'sizes', desc: '', args: []);
  }

  /// `Registered Before`
  String get registered_before {
    return Intl.message(
      'Registered Before',
      name: 'registered_before',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get max {
    return Intl.message('Max', name: 'max', desc: '', args: []);
  }

  /// `Apply filters`
  String get apply_filters {
    return Intl.message(
      'Apply filters',
      name: 'apply_filters',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `Colors`
  String get colors {
    return Intl.message('Colors', name: 'colors', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `New Check Your Email For\nConfirmation Link`
  String get new_check_email {
    return Intl.message(
      'New Check Your Email For\nConfirmation Link',
      name: 'new_check_email',
      desc: '',
      args: [],
    );
  }

  /// `Expiration`
  String get expiration {
    return Intl.message('Expiration', name: 'expiration', desc: '', args: []);
  }

  /// `Save For Later?`
  String get save_for_later {
    return Intl.message(
      'Save For Later?',
      name: 'save_for_later',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Confirm Address`
  String get confirm_address {
    return Intl.message(
      'Confirm Address',
      name: 'confirm_address',
      desc: '',
      args: [],
    );
  }

  /// `Cvc`
  String get cvc {
    return Intl.message('Cvc', name: 'cvc', desc: '', args: []);
  }

  /// `Card Name`
  String get card_name {
    return Intl.message('Card Name', name: 'card_name', desc: '', args: []);
  }

  /// `Card Number`
  String get card_number {
    return Intl.message('Card Number', name: 'card_number', desc: '', args: []);
  }

  /// `Payment Summary`
  String get payment_summary {
    return Intl.message(
      'Payment Summary',
      name: 'payment_summary',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Additional service`
  String get additional_service {
    return Intl.message(
      'Additional service',
      name: 'additional_service',
      desc: '',
      args: [],
    );
  }

  /// `Order summary`
  String get order_summary {
    return Intl.message(
      'Order summary',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get coupon_code {
    return Intl.message('Coupon Code', name: 'coupon_code', desc: '', args: []);
  }

  /// `This Code Is Invalid CODE`
  String get code_invalid {
    return Intl.message(
      'This Code Is Invalid CODE',
      name: 'code_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message('Wishlist', name: 'wishlist', desc: '', args: []);
  }

  /// `Related Products`
  String get related_products {
    return Intl.message(
      'Related Products',
      name: 'related_products',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get add_to_cart {
    return Intl.message('Add To Cart', name: 'add_to_cart', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `New Arrival`
  String get new_arrival {
    return Intl.message('New Arrival', name: 'new_arrival', desc: '', args: []);
  }

  /// `Required`
  String get is_required {
    return Intl.message('Required', name: 'is_required', desc: '', args: []);
  }

  /// `Oops!`
  String get oops {
    return Intl.message('Oops!', name: 'oops', desc: '', args: []);
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Password And Confirm.`
  String get enter_new_password_and_confirm {
    return Intl.message(
      'Enter New Password And Confirm.',
      name: 'enter_new_password_and_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `update`
  String get update {
    return Intl.message('update', name: 'update', desc: '', args: []);
  }

  /// `governor`
  String get governor {
    return Intl.message('governor', name: 'governor', desc: '', args: []);
  }

  /// `receiverPhone`
  String get receiverPhone {
    return Intl.message(
      'receiverPhone',
      name: 'receiverPhone',
      desc: '',
      args: [],
    );
  }

  /// `Select Governor`
  String get selectGovernor {
    return Intl.message(
      'Select Governor',
      name: 'selectGovernor',
      desc: '',
      args: [],
    );
  }

  /// `From Map`
  String get selectFromMap {
    return Intl.message('From Map', name: 'selectFromMap', desc: '', args: []);
  }

  /// `My Location`
  String get myLocation {
    return Intl.message('My Location', name: 'myLocation', desc: '', args: []);
  }

  /// `start with 07 and 11 digit`
  String get helperPhoneText {
    return Intl.message(
      'start with 07 and 11 digit',
      name: 'helperPhoneText',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, Your Search Is \nNot Available`
  String get emptySearch {
    return Intl.message(
      'Sorry, Your Search Is \nNot Available',
      name: 'emptySearch',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, There Are \nNo Requests`
  String get emptyCart {
    return Intl.message(
      'Sorry, There Are \nNo Requests',
      name: 'emptyCart',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, There Are \nNo Requests`
  String get emptyFav {
    return Intl.message(
      'Sorry, There Are \nNo Requests',
      name: 'emptyFav',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, There Are \nNo Offers`
  String get emptyOffers {
    return Intl.message(
      'Sorry, There Are \nNo Offers',
      name: 'emptyOffers',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, There Are \nNo Notifications`
  String get emptyNotifications {
    return Intl.message(
      'Sorry, There Are \nNo Notifications',
      name: 'emptyNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, There Are \nNo Orders`
  String get emptyOrders {
    return Intl.message(
      'Sorry, There Are \nNo Orders',
      name: 'emptyOrders',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Address`
  String get confirmAddress {
    return Intl.message(
      'Confirm Address',
      name: 'confirmAddress',
      desc: '',
      args: [],
    );
  }

  /// `Cash Payment`
  String get cashPayment {
    return Intl.message(
      'Cash Payment',
      name: 'cashPayment',
      desc: '',
      args: [],
    );
  }

  /// `E-Payment`
  String get ePayment {
    return Intl.message('E-Payment', name: 'ePayment', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Order Created`
  String get donePending {
    return Intl.message(
      'Order Created',
      name: 'donePending',
      desc: '',
      args: [],
    );
  }

  /// `Order Processed`
  String get doneProcessing {
    return Intl.message(
      'Order Processed',
      name: 'doneProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Order Was Ready`
  String get doneReady {
    return Intl.message(
      'Order Was Ready',
      name: 'doneReady',
      desc: '',
      args: [],
    );
  }

  /// `Order Shipped`
  String get doneShipping {
    return Intl.message(
      'Order Shipped',
      name: 'doneShipping',
      desc: '',
      args: [],
    );
  }

  /// `Order Completed`
  String get doneCompleted {
    return Intl.message(
      'Order Completed',
      name: 'doneCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Order Canceled`
  String get doneCanceled {
    return Intl.message(
      'Order Canceled',
      name: 'doneCanceled',
      desc: '',
      args: [],
    );
  }

  /// ` PaymentFailed`
  String get donePaymentFailed {
    return Intl.message(
      ' PaymentFailed',
      name: 'donePaymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Order Returned`
  String get doneReturned {
    return Intl.message(
      'Order Returned',
      name: 'doneReturned',
      desc: '',
      args: [],
    );
  }

  /// `At`
  String get at {
    return Intl.message('At', name: 'at', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Processing`
  String get processing {
    return Intl.message('Processing', name: 'processing', desc: '', args: []);
  }

  /// `Ready`
  String get ready {
    return Intl.message('Ready', name: 'ready', desc: '', args: []);
  }

  /// `Shipping`
  String get shipping {
    return Intl.message('Shipping', name: 'shipping', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Canceled`
  String get canceled {
    return Intl.message('Canceled', name: 'canceled', desc: '', args: []);
  }

  /// `Payment Failed`
  String get paymentFailed {
    return Intl.message(
      'Payment Failed',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get returned {
    return Intl.message('Returned', name: 'returned', desc: '', args: []);
  }

  /// `Not Yet`
  String get notYet {
    return Intl.message('Not Yet', name: 'notYet', desc: '', args: []);
  }

  /// `Tracking Order`
  String get trackingOrder {
    return Intl.message(
      'Tracking Order',
      name: 'trackingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Your Order`
  String get yourOrder {
    return Intl.message('Your Order', name: 'yourOrder', desc: '', args: []);
  }

  /// `Delivery Date`
  String get deliveryDate {
    return Intl.message(
      'Delivery Date',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Ready To Deliver`
  String get readyToDeliver {
    return Intl.message(
      'Ready To Deliver',
      name: 'readyToDeliver',
      desc: '',
      args: [],
    );
  }

  /// `Estimated For`
  String get estimatedFor {
    return Intl.message(
      'Estimated For',
      name: 'estimatedFor',
      desc: '',
      args: [],
    );
  }

  /// `Pleas Set Your Address`
  String get pleasSetYourAddress {
    return Intl.message(
      'Pleas Set Your Address',
      name: 'pleasSetYourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Review Order`
  String get reviewOrder {
    return Intl.message(
      'Review Order',
      name: 'reviewOrder',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get en {
    return Intl.message('English', name: 'en', desc: '', args: []);
  }

  /// `Arabic`
  String get ar {
    return Intl.message('Arabic', name: 'ar', desc: '', args: []);
  }

  /// `Kurdish`
  String get ku {
    return Intl.message('Kurdish', name: 'ku', desc: '', args: []);
  }

  /// `Dollar`
  String get dollar {
    return Intl.message('Dollar', name: 'dollar', desc: '', args: []);
  }

  /// `Dinar`
  String get dinar {
    return Intl.message('Dinar', name: 'dinar', desc: '', args: []);
  }

  /// `Please Send Your Rating For The Product`
  String get setReview {
    return Intl.message(
      'Please Send Your Rating For The Product',
      name: 'setReview',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews found`
  String get emptyReview {
    return Intl.message(
      'No Reviews found',
      name: 'emptyReview',
      desc: '',
      args: [],
    );
  }

  /// `Add Review`
  String get addReview {
    return Intl.message('Add Review', name: 'addReview', desc: '', args: []);
  }

  /// `Search Result`
  String get searchResult {
    return Intl.message(
      'Search Result',
      name: 'searchResult',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Sub Categories`
  String get subCategories {
    return Intl.message(
      'Sub Categories',
      name: 'subCategories',
      desc: '',
      args: [],
    );
  }

  /// `Rated`
  String get rated {
    return Intl.message('Rated', name: 'rated', desc: '', args: []);
  }

  /// `Sign In With Social Networks`
  String get signInWithSocialNetworks {
    return Intl.message(
      'Sign In With Social Networks',
      name: 'signInWithSocialNetworks',
      desc: '',
      args: [],
    );
  }

  /// `Done Payment`
  String get confirmPayment {
    return Intl.message(
      'Done Payment',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Please Log In to continue `
  String get needLogin {
    return Intl.message(
      'Please Log In to continue ',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Your Location`
  String get yourLocation {
    return Intl.message(
      'Your Location',
      name: 'yourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Identity Image`
  String get identityImage {
    return Intl.message(
      'Identity Image',
      name: 'identityImage',
      desc: '',
      args: [],
    );
  }

  /// `Done Pick`
  String get donePick {
    return Intl.message('Done Pick', name: 'donePick', desc: '', args: []);
  }

  /// `Click To Update`
  String get clickToUpdate {
    return Intl.message(
      'Click To Update',
      name: 'clickToUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get profileImage {
    return Intl.message(
      'Profile Image',
      name: 'profileImage',
      desc: '',
      args: [],
    );
  }

  /// `The code has been sent! If necessary, we can resend the code up to two additional times.`
  String get doneSendCode {
    return Intl.message(
      'The code has been sent! If necessary, we can resend the code up to two additional times.',
      name: 'doneSendCode',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a text message containing your verification code to the phone number: `
  String get doneSendSms {
    return Intl.message(
      'We have sent a text message containing your verification code to the phone number: ',
      name: 'doneSendSms',
      desc: '',
      args: [],
    );
  }

  /// `Remember Password`
  String get rememberPassword {
    return Intl.message(
      'Remember Password',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get isSuccess {
    return Intl.message('Success!', name: 'isSuccess', desc: '', args: []);
  }

  /// `Confirm Your Phone`
  String get confirmYourPhone {
    return Intl.message(
      'Confirm Your Phone',
      name: 'confirmYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Welcome To`
  String get welcomeTo {
    return Intl.message('Welcome To', name: 'welcomeTo', desc: '', args: []);
  }

  /// `E-Move`
  String get eMove {
    return Intl.message('E-Move', name: 'eMove', desc: '', args: []);
  }

  /// `Secured`
  String get secured {
    return Intl.message('Secured', name: 'secured', desc: '', args: []);
  }

  /// `trips`
  String get trips {
    return Intl.message('trips', name: 'trips', desc: '', args: []);
  }

  /// `shipments`
  String get shipments {
    return Intl.message('shipments', name: 'shipments', desc: '', args: []);
  }

  /// `pay`
  String get pay {
    return Intl.message('pay', name: 'pay', desc: '', args: []);
  }

  /// `ern`
  String get ern {
    return Intl.message('ern', name: 'ern', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Track Shipment`
  String get trackShipment {
    return Intl.message(
      'Track Shipment',
      name: 'trackShipment',
      desc: '',
      args: [],
    );
  }

  /// `Make your own money easily`
  String get makeMoney {
    return Intl.message(
      'Make your own money easily',
      name: 'makeMoney',
      desc: '',
      args: [],
    );
  }

  /// `Locations`
  String get locations {
    return Intl.message('Locations', name: 'locations', desc: '', args: []);
  }

  /// `book your shipment\n online`
  String get bookYourShipment {
    return Intl.message(
      'book your shipment\n online',
      name: 'bookYourShipment',
      desc: '',
      args: [],
    );
  }

  /// `Send your packages safely and quickly`
  String get sendYourPackages {
    return Intl.message(
      'Send your packages safely and quickly',
      name: 'sendYourPackages',
      desc: '',
      args: [],
    );
  }

  /// `We guarantee all your data that\n you provide `
  String get intro1 {
    return Intl.message(
      'We guarantee all your data that\n you provide ',
      name: 'intro1',
      desc: '',
      args: [],
    );
  }

  /// `only 5 steps you book your shipment online and have it delivered`
  String get intro2 {
    return Intl.message(
      'only 5 steps you book your shipment online and have it delivered',
      name: 'intro2',
      desc: '',
      args: [],
    );
  }

  /// `The place to send & receive your packages\n safely and quickly`
  String get intro3 {
    return Intl.message(
      'The place to send & receive your packages\n safely and quickly',
      name: 'intro3',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Id Photo`
  String get idPhoto {
    return Intl.message('Id Photo', name: 'idPhoto', desc: '', args: []);
  }

  /// `Id Number`
  String get idNumber {
    return Intl.message('Id Number', name: 'idNumber', desc: '', args: []);
  }

  /// `Id Expiry`
  String get idExpiry {
    return Intl.message('Id Expiry', name: 'idExpiry', desc: '', args: []);
  }

  /// `Id Type`
  String get idType {
    return Intl.message('Id Type', name: 'idType', desc: '', args: []);
  }

  /// `Paired`
  String get paired {
    return Intl.message('Paired', name: 'paired', desc: '', args: []);
  }

  /// `Un paired`
  String get unPaired {
    return Intl.message('Un paired', name: 'unPaired', desc: '', args: []);
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Dropped`
  String get dropped {
    return Intl.message('Dropped', name: 'dropped', desc: '', args: []);
  }

  /// `Carried`
  String get carried {
    return Intl.message('Carried', name: 'carried', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Suspended`
  String get suspended {
    return Intl.message('Suspended', name: 'suspended', desc: '', args: []);
  }

  /// `New`
  String get new_ {
    return Intl.message('New', name: 'new_', desc: '', args: []);
  }

  /// `Shipment`
  String get shipment {
    return Intl.message('Shipment', name: 'shipment', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Destinations`
  String get destinations {
    return Intl.message(
      'Destinations',
      name: 'destinations',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get destination {
    return Intl.message('Destination', name: 'destination', desc: '', args: []);
  }

  /// `Source`
  String get source {
    return Intl.message('Source', name: 'source', desc: '', args: []);
  }

  /// `Arrived`
  String get arrived {
    return Intl.message('Arrived', name: 'arrived', desc: '', args: []);
  }

  /// `Drop`
  String get drop {
    return Intl.message('Drop', name: 'drop', desc: '', args: []);
  }

  /// `Office`
  String get office {
    return Intl.message('Office', name: 'office', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Package`
  String get package {
    return Intl.message('Package', name: 'package', desc: '', args: []);
  }

  /// `Data`
  String get data {
    return Intl.message('Data', name: 'data', desc: '', args: []);
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `number`
  String get number {
    return Intl.message('number', name: 'number', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Trip`
  String get trip {
    return Intl.message('Trip', name: 'trip', desc: '', args: []);
  }

  /// `Pickup`
  String get pickup {
    return Intl.message('Pickup', name: 'pickup', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Add Pairing`
  String get addPairing {
    return Intl.message('Add Pairing', name: 'addPairing', desc: '', args: []);
  }

  /// `Between`
  String get between {
    return Intl.message('Between', name: 'between', desc: '', args: []);
  }

  /// `Insured`
  String get insured {
    return Intl.message('Insured', name: 'insured', desc: '', args: []);
  }

  /// `Track`
  String get track {
    return Intl.message('Track', name: 'track', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Suggested requests`
  String get suggestedRequests {
    return Intl.message(
      'Suggested requests',
      name: 'suggestedRequests',
      desc: '',
      args: [],
    );
  }

  /// `Suggested Travelers`
  String get suggestedTravelers {
    return Intl.message(
      'Suggested Travelers',
      name: 'suggestedTravelers',
      desc: '',
      args: [],
    );
  }

  /// `Special instructions`
  String get specialInstructions {
    return Intl.message(
      'Special instructions',
      name: 'specialInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the shipment number you want to \ntrack :`
  String get enterShipmentTracking {
    return Intl.message(
      'Please enter the shipment number you want to \ntrack :',
      name: 'enterShipmentTracking',
      desc: '',
      args: [],
    );
  }

  /// `Shipment Tracking`
  String get shipmentTracking {
    return Intl.message(
      'Shipment Tracking',
      name: 'shipmentTracking',
      desc: '',
      args: [],
    );
  }

  /// `All Request`
  String get allRequest {
    return Intl.message('All Request', name: 'allRequest', desc: '', args: []);
  }

  /// `notifications`
  String get notifications {
    return Intl.message(
      'notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Ignore`
  String get ignore {
    return Intl.message('Ignore', name: 'ignore', desc: '', args: []);
  }

  /// `Detailed tracking hestory`
  String get detailedTrackingHestory {
    return Intl.message(
      'Detailed tracking hestory',
      name: 'detailedTrackingHestory',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Beneficiary`
  String get beneficiary {
    return Intl.message('Beneficiary', name: 'beneficiary', desc: '', args: []);
  }

  /// `Find match for this`
  String get findMatchForThis {
    return Intl.message(
      'Find match for this',
      name: 'findMatchForThis',
      desc: '',
      args: [],
    );
  }

  /// `Find Trip`
  String get findTrip {
    return Intl.message('Find Trip', name: 'findTrip', desc: '', args: []);
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Suggestions`
  String get suggestions {
    return Intl.message('Suggestions', name: 'suggestions', desc: '', args: []);
  }

  /// `Request and Suggestion`
  String get requestAndSuggestion {
    return Intl.message(
      'Request and Suggestion',
      name: 'requestAndSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Find Shipment`
  String get findShipment {
    return Intl.message(
      'Find Shipment',
      name: 'findShipment',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Travail from:`
  String get travailFrom {
    return Intl.message(
      'Travail from:',
      name: 'travailFrom',
      desc: '',
      args: [],
    );
  }

  /// `My trips`
  String get myTrips {
    return Intl.message('My trips', name: 'myTrips', desc: '', args: []);
  }

  /// `Make trips Make money`
  String get makeTripsMakeMoney {
    return Intl.message(
      'Make trips Make money',
      name: 'makeTripsMakeMoney',
      desc: '',
      args: [],
    );
  }

  /// `My shipments`
  String get myShipments {
    return Intl.message(
      'My shipments',
      name: 'myShipments',
      desc: '',
      args: [],
    );
  }

  /// `Save money and sending Shipments`
  String get saveMoneyAndSendingShipments {
    return Intl.message(
      'Save money and sending Shipments',
      name: 'saveMoneyAndSendingShipments',
      desc: '',
      args: [],
    );
  }

  /// `Tracking shipment`
  String get trackingShipment {
    return Intl.message(
      'Tracking shipment',
      name: 'trackingShipment',
      desc: '',
      args: [],
    );
  }

  /// `Active paring:`
  String get activeParing {
    return Intl.message(
      'Active paring:',
      name: 'activeParing',
      desc: '',
      args: [],
    );
  }

  /// `Show QR`
  String get showQr {
    return Intl.message('Show QR', name: 'showQr', desc: '', args: []);
  }

  /// `Arriving date:`
  String get arrivingDate {
    return Intl.message(
      'Arriving date:',
      name: 'arrivingDate',
      desc: '',
      args: [],
    );
  }

  /// `before`
  String get before {
    return Intl.message('before', name: 'before', desc: '', args: []);
  }

  /// `Can`
  String get can {
    return Intl.message('Can', name: 'can', desc: '', args: []);
  }

  /// `Delivering to the office`
  String get deliveringToTheOffice {
    return Intl.message(
      'Delivering to the office',
      name: 'deliveringToTheOffice',
      desc: '',
      args: [],
    );
  }

  /// `Expected arrival`
  String get expectedArrival {
    return Intl.message(
      'Expected arrival',
      name: 'expectedArrival',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Paring Manage`
  String get paringManage {
    return Intl.message(
      'Paring Manage',
      name: 'paringManage',
      desc: '',
      args: [],
    );
  }

  /// `Find Match`
  String get findMatch {
    return Intl.message('Find Match', name: 'findMatch', desc: '', args: []);
  }

  /// `Pairings`
  String get pairings {
    return Intl.message('Pairings', name: 'pairings', desc: '', args: []);
  }

  /// `Yes,cancel`
  String get yescancel {
    return Intl.message('Yes,cancel', name: 'yescancel', desc: '', args: []);
  }

  /// `Offers`
  String get offers {
    return Intl.message('Offers', name: 'offers', desc: '', args: []);
  }

  /// `loan`
  String get loan {
    return Intl.message('loan', name: 'loan', desc: '', args: []);
  }

  /// `portfolio`
  String get portfolio {
    return Intl.message('portfolio', name: 'portfolio', desc: '', args: []);
  }

  /// `short list`
  String get shortList {
    return Intl.message('short list', name: 'shortList', desc: '', args: []);
  }

  /// `wallet`
  String get wallet {
    return Intl.message('wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Portfolio info`
  String get portfolioInfo {
    return Intl.message(
      'Portfolio info',
      name: 'portfolioInfo',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get tools {
    return Intl.message('Tools', name: 'tools', desc: '', args: []);
  }

  /// `Loan Offers`
  String get loanOffers {
    return Intl.message('Loan Offers', name: 'loanOffers', desc: '', args: []);
  }

  /// `Bank`
  String get bank {
    return Intl.message('Bank', name: 'bank', desc: '', args: []);
  }

  /// `Loan type`
  String get loanType {
    return Intl.message('Loan type', name: 'loanType', desc: '', args: []);
  }

  /// `Create short list folder?`
  String get createShortListFolder {
    return Intl.message(
      'Create short list folder?',
      name: 'createShortListFolder',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message('Dismiss', name: 'dismiss', desc: '', args: []);
  }

  /// `Folder name`
  String get folderName {
    return Intl.message('Folder name', name: 'folderName', desc: '', args: []);
  }

  /// `Create new folder to add and categorize favorite offers`
  String get createNewFolder {
    return Intl.message(
      'Create new folder to add and categorize favorite offers',
      name: 'createNewFolder',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `APR`
  String get apr {
    return Intl.message('APR', name: 'apr', desc: '', args: []);
  }

  /// `Term`
  String get term {
    return Intl.message('Term', name: 'term', desc: '', args: []);
  }

  /// `Fees`
  String get fees {
    return Intl.message('Fees', name: 'fees', desc: '', args: []);
  }

  /// `months`
  String get months {
    return Intl.message('months', name: 'months', desc: '', args: []);
  }

  /// `You have a list with the same name.`
  String get sameNameShortList {
    return Intl.message(
      'You have a list with the same name.',
      name: 'sameNameShortList',
      desc: '',
      args: [],
    );
  }

  /// `Late fee`
  String get lateFee {
    return Intl.message('Late fee', name: 'lateFee', desc: '', args: []);
  }

  /// `Grace period`
  String get gracePeriod {
    return Intl.message(
      'Grace period',
      name: 'gracePeriod',
      desc: '',
      args: [],
    );
  }

  /// `Approval Requirements`
  String get approvalRequirements {
    return Intl.message(
      'Approval Requirements',
      name: 'approvalRequirements',
      desc: '',
      args: [],
    );
  }

  /// `Checking account`
  String get checkingAccount {
    return Intl.message(
      'Checking account',
      name: 'checkingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Saving account`
  String get savingAccount {
    return Intl.message(
      'Saving account',
      name: 'savingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Loan Offer Details`
  String get loanOfferDetails {
    return Intl.message(
      'Loan Offer Details',
      name: 'loanOfferDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add to short list`
  String get addToShortList {
    return Intl.message(
      'Add to short list',
      name: 'addToShortList',
      desc: '',
      args: [],
    );
  }

  /// `Add offer to short list?`
  String get addOfferToShortList {
    return Intl.message(
      'Add offer to short list?',
      name: 'addOfferToShortList',
      desc: '',
      args: [],
    );
  }

  /// `The offer will be saved in the list of your choice.`
  String get theOfferWillBeSaved {
    return Intl.message(
      'The offer will be saved in the list of your choice.',
      name: 'theOfferWillBeSaved',
      desc: '',
      args: [],
    );
  }

  /// `Remove from short list`
  String get removeFromShortList {
    return Intl.message(
      'Remove from short list',
      name: 'removeFromShortList',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Personal`
  String get personal {
    return Intl.message('Personal', name: 'personal', desc: '', args: []);
  }

  /// `Financial`
  String get financial {
    return Intl.message('Financial', name: 'financial', desc: '', args: []);
  }

  /// `Legal`
  String get legal {
    return Intl.message('Legal', name: 'legal', desc: '', args: []);
  }

  /// `my profile`
  String get myProfile {
    return Intl.message('my profile', name: 'myProfile', desc: '', args: []);
  }

  /// `more info`
  String get moreInfo {
    return Intl.message('more info', name: 'moreInfo', desc: '', args: []);
  }

  /// `years old`
  String get yearsOld {
    return Intl.message('years old', name: 'yearsOld', desc: '', args: []);
  }

  /// `last range`
  String get lastRange {
    return Intl.message('last range', name: 'lastRange', desc: '', args: []);
  }

  /// `first range`
  String get firstRange {
    return Intl.message('first range', name: 'firstRange', desc: '', args: []);
  }

  /// `first`
  String get first {
    return Intl.message('first', name: 'first', desc: '', args: []);
  }

  /// `last`
  String get last {
    return Intl.message('last', name: 'last', desc: '', args: []);
  }

  /// `Bank Type`
  String get bankType {
    return Intl.message('Bank Type', name: 'bankType', desc: '', args: []);
  }

  /// `Member detail`
  String get memberDetail {
    return Intl.message(
      'Member detail',
      name: 'memberDetail',
      desc: '',
      args: [],
    );
  }

  /// `Bank Details`
  String get bankDetails {
    return Intl.message(
      'Bank Details',
      name: 'bankDetails',
      desc: '',
      args: [],
    );
  }

  /// `sort`
  String get sort {
    return Intl.message('sort', name: 'sort', desc: '', args: []);
  }

  /// `Descending`
  String get desc {
    return Intl.message('Descending', name: 'desc', desc: '', args: []);
  }

  /// `Ascending`
  String get asc {
    return Intl.message('Ascending', name: 'asc', desc: '', args: []);
  }

  /// `clear`
  String get clear {
    return Intl.message('clear', name: 'clear', desc: '', args: []);
  }

  /// `An error with your network`
  String get anErrorWithYourNetwork {
    return Intl.message(
      'An error with your network',
      name: 'anErrorWithYourNetwork',
      desc: '',
      args: [],
    );
  }

  /// `connection Time Out`
  String get connectionTimeOut {
    return Intl.message(
      'connection Time Out',
      name: 'connectionTimeOut',
      desc: '',
      args: [],
    );
  }

  /// `Server side error `
  String get serverSideError {
    return Intl.message(
      'Server side error ',
      name: 'serverSideError',
      desc: '',
      args: [],
    );
  }

  /// `User Logout`
  String get userLogout {
    return Intl.message('User Logout', name: 'userLogout', desc: '', args: []);
  }

  /// `Answer Needed`
  String get answerNeeded {
    return Intl.message(
      'Answer Needed',
      name: 'answerNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Need`
  String get need {
    return Intl.message('Need', name: 'need', desc: '', args: []);
  }

  /// `Approve answer`
  String get approveAnswer {
    return Intl.message(
      'Approve answer',
      name: 'approveAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `Top offers`
  String get topOffers {
    return Intl.message('Top offers', name: 'topOffers', desc: '', args: []);
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `Show in wallet`
  String get showInWallet {
    return Intl.message(
      'Show in wallet',
      name: 'showInWallet',
      desc: '',
      args: [],
    );
  }

  /// `welcome`
  String get welcome {
    return Intl.message('welcome', name: 'welcome', desc: '', args: []);
  }

  /// `loan offers found`
  String get loanOffersFound {
    return Intl.message(
      'loan offers found',
      name: 'loanOffersFound',
      desc: '',
      args: [],
    );
  }

  /// `loanTypeId`
  String get loantypeid {
    return Intl.message('loanTypeId', name: 'loantypeid', desc: '', args: []);
  }

  /// `Add loan offers`
  String get addLoanOffers {
    return Intl.message(
      'Add loan offers',
      name: 'addLoanOffers',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile !`
  String get completeYourProfile {
    return Intl.message(
      'Complete your profile !',
      name: 'completeYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Bot X,`
  String get welcomeToUs {
    return Intl.message(
      'Welcome to Bot X,',
      name: 'welcomeToUs',
      desc: '',
      args: [],
    );
  }

  /// `Hello there, create New account`
  String get helloThereCreateNewAccount {
    return Intl.message(
      'Hello there, create New account',
      name: 'helloThereCreateNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Type your phone number`
  String get typeYourPhoneNumber {
    return Intl.message(
      'Type your phone number',
      name: 'typeYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `We texted you a code to verify your phone number`
  String get weTextedYouACodeToVerifyYourPhoneNumber {
    return Intl.message(
      'We texted you a code to verify your phone number',
      name: 'weTextedYouACodeToVerifyYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `compare`
  String get compare {
    return Intl.message('compare', name: 'compare', desc: '', args: []);
  }

  /// `Applications`
  String get applications {
    return Intl.message(
      'Applications',
      name: 'applications',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Exam date:`
  String get examDate {
    return Intl.message('Exam date:', name: 'examDate', desc: '', args: []);
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `year`
  String get year {
    return Intl.message('year', name: 'year', desc: '', args: []);
  }

  /// `years`
  String get years {
    return Intl.message('years', name: 'years', desc: '', args: []);
  }

  /// `day`
  String get day {
    return Intl.message('day', name: 'day', desc: '', args: []);
  }

  /// `hour`
  String get hour {
    return Intl.message('hour', name: 'hour', desc: '', args: []);
  }

  /// `seconds`
  String get second {
    return Intl.message('seconds', name: 'second', desc: '', args: []);
  }

  /// `minute`
  String get minute {
    return Intl.message('minute', name: 'minute', desc: '', args: []);
  }

  /// `Not Answer`
  String get notAnswer {
    return Intl.message('Not Answer', name: 'notAnswer', desc: '', args: []);
  }

  /// `Not Sure`
  String get notSure {
    return Intl.message('Not Sure', name: 'notSure', desc: '', args: []);
  }

  /// `Sure`
  String get sure {
    return Intl.message('Sure', name: 'sure', desc: '', args: []);
  }

  /// `Remaining:`
  String get remaining {
    return Intl.message('Remaining:', name: 'remaining', desc: '', args: []);
  }

  /// `Submit answers and exit exam`
  String get submitAnswersAndExitExam {
    return Intl.message(
      'Submit answers and exit exam',
      name: 'submitAnswersAndExitExam',
      desc: '',
      args: [],
    );
  }

  /// `The allocated time for the exam has ended.\n No further answers or modifications can be made.\n Your answers will be saved automatically.`
  String get theAllocatedTimeForTheExamHasEndedNoFurther {
    return Intl.message(
      'The allocated time for the exam has ended.\n No further answers or modifications can be made.\n Your answers will be saved automatically.',
      name: 'theAllocatedTimeForTheExamHasEndedNoFurther',
      desc: '',
      args: [],
    );
  }

  /// `You are about to submit the exam, but there are questions that are either unanswered or marked as uncertain.\nAre you sure you want to submit the exam?`
  String get youAreAboutToSubmitTheExamButThereAre {
    return Intl.message(
      'You are about to submit the exam, but there are questions that are either unanswered or marked as uncertain.\nAre you sure you want to submit the exam?',
      name: 'youAreAboutToSubmitTheExamButThereAre',
      desc: '',
      args: [],
    );
  }

  /// `All questions have been answered and reviewed. \nAre you sure you want to submit the exam?`
  String get allQuestionsHaveBeenAnsweredAndReviewedAreYouSure {
    return Intl.message(
      'All questions have been answered and reviewed. \nAre you sure you want to submit the exam?',
      name: 'allQuestionsHaveBeenAnsweredAndReviewedAreYouSure',
      desc: '',
      args: [],
    );
  }

  /// `course Topic`
  String get courseTopic {
    return Intl.message(
      'course Topic',
      name: 'courseTopic',
      desc: '',
      args: [],
    );
  }

  /// `mark`
  String get mark {
    return Intl.message('mark', name: 'mark', desc: '', args: []);
  }

  /// `if click start timer will start and your device will lock`
  String get ifClickStartTimerWillStartAndYourDeviceWill {
    return Intl.message(
      'if click start timer will start and your device will lock',
      name: 'ifClickStartTimerWillStartAndYourDeviceWill',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message('Now', name: 'now', desc: '', args: []);
  }

  /// `Note: This step is required to begin your exam`
  String get noteThisStepIsRequiredToBeginYourExam {
    return Intl.message(
      'Note: This step is required to begin your exam',
      name: 'noteThisStepIsRequiredToBeginYourExam',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message('Scan', name: 'scan', desc: '', args: []);
  }

  /// `Verification Failed`
  String get verificationFailed {
    return Intl.message(
      'Verification Failed',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `More than one face detected`
  String get moreThanOneFaceDetected {
    return Intl.message(
      'More than one face detected',
      name: 'moreThanOneFaceDetected',
      desc: '',
      args: [],
    );
  }

  /// `No face detected`
  String get noFaceDetected {
    return Intl.message(
      'No face detected',
      name: 'noFaceDetected',
      desc: '',
      args: [],
    );
  }

  /// `Show image`
  String get showImage {
    return Intl.message('Show image', name: 'showImage', desc: '', args: []);
  }

  /// `SignIn to stay connected`
  String get signinToStayConnected {
    return Intl.message(
      'SignIn to stay connected',
      name: 'signinToStayConnected',
      desc: '',
      args: [],
    );
  }

  /// `Start Exam`
  String get startExam {
    return Intl.message('Start Exam', name: 'startExam', desc: '', args: []);
  }

  /// `Close exam`
  String get closeExam {
    return Intl.message('Close exam', name: 'closeExam', desc: '', args: []);
  }

  /// `Monitor Exam Page`
  String get monitorExamPage {
    return Intl.message(
      'Monitor Exam Page',
      name: 'monitorExamPage',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
  }

  /// `All students`
  String get allStudents {
    return Intl.message(
      'All students',
      name: 'allStudents',
      desc: '',
      args: [],
    );
  }

  /// `Check microphone`
  String get checkMicrophone {
    return Intl.message(
      'Check microphone',
      name: 'checkMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Rescan`
  String get rescan {
    return Intl.message('Rescan', name: 'rescan', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Record`
  String get record {
    return Intl.message('Record', name: 'record', desc: '', args: []);
  }

  /// `Play`
  String get play {
    return Intl.message('Play', name: 'play', desc: '', args: []);
  }

  /// `Re record`
  String get reRecord {
    return Intl.message('Re record', name: 'reRecord', desc: '', args: []);
  }

  /// `Show Media`
  String get showMedia {
    return Intl.message('Show Media', name: 'showMedia', desc: '', args: []);
  }

  /// `Group`
  String get group {
    return Intl.message('Group', name: 'group', desc: '', args: []);
  }

  /// `Need review ?`
  String get needReview {
    return Intl.message(
      'Need review ?',
      name: 'needReview',
      desc: '',
      args: [],
    );
  }

  /// `Connection`
  String get connection {
    return Intl.message('Connection', name: 'connection', desc: '', args: []);
  }

  /// `Let’s Start`
  String get letsStart {
    return Intl.message('Let’s Start', name: 'letsStart', desc: '', args: []);
  }

  /// `Log in to Your Bot X`
  String get logInToYourWallet {
    return Intl.message(
      'Log in to Your Bot X',
      name: 'logInToYourWallet',
      desc: '',
      args: [],
    );
  }

  /// `Enter your registered email address for secure login.`
  String get enterYourRegisteredEmailAddressForSecureLogin {
    return Intl.message(
      'Enter your registered email address for secure login.',
      name: 'enterYourRegisteredEmailAddressForSecureLogin',
      desc: '',
      args: [],
    );
  }

  /// `Login successful! Welcome back to`
  String get loginSuccessfulWelcomeBackTo {
    return Intl.message(
      'Login successful! Welcome back to',
      name: 'loginSuccessfulWelcomeBackTo',
      desc: '',
      args: [],
    );
  }

  /// `Swap X`
  String get swapX {
    return Intl.message('Swap X', name: 'swapX', desc: '', args: []);
  }

  /// `If you don’t have an account`
  String get ifYouDontHaveAnAccount {
    return Intl.message(
      'If you don’t have an account',
      name: 'ifYouDontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `Recent Swaps`
  String get recentSwaps {
    return Intl.message(
      'Recent Swaps',
      name: 'recentSwaps',
      desc: '',
      args: [],
    );
  }

  /// `Didn’t receive the OTP`
  String get didntReceiveTheOtp {
    return Intl.message(
      'Didn’t receive the OTP',
      name: 'didntReceiveTheOtp',
      desc: '',
      args: [],
    );
  }

  /// `Create your Password`
  String get createYourPassword {
    return Intl.message(
      'Create your Password',
      name: 'createYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter something you will remember`
  String get pleaseEnterSomethingYouWillRemember {
    return Intl.message(
      'Please enter something you will remember',
      name: 'pleaseEnterSomethingYouWillRemember',
      desc: '',
      args: [],
    );
  }

  /// `Create password`
  String get createPassword {
    return Intl.message(
      'Create password',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your balance`
  String get yourBalance {
    return Intl.message(
      'Your balance',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `Create wallet`
  String get createWallet {
    return Intl.message(
      'Create wallet',
      name: 'createWallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet name`
  String get walletName {
    return Intl.message('Wallet name', name: 'walletName', desc: '', args: []);
  }

  /// `Wallet address`
  String get walletAddress {
    return Intl.message(
      'Wallet address',
      name: 'walletAddress',
      desc: '',
      args: [],
    );
  }

  /// `Wallet privateKey`
  String get walletPrivatekey {
    return Intl.message(
      'Wallet privateKey',
      name: 'walletPrivatekey',
      desc: '',
      args: [],
    );
  }

  /// `Wallet id`
  String get walletId {
    return Intl.message('Wallet id', name: 'walletId', desc: '', args: []);
  }

  /// `Select the kol you want to view`
  String get selectTheKolYouWantToView {
    return Intl.message(
      'Select the kol you want to view',
      name: 'selectTheKolYouWantToView',
      desc: '',
      args: [],
    );
  }

  /// `KLOs`
  String get klos {
    return Intl.message('KLOs', name: 'klos', desc: '', args: []);
  }

  /// `Token Swap`
  String get tokenSwap {
    return Intl.message('Token Swap', name: 'tokenSwap', desc: '', args: []);
  }

  /// `Swap Details`
  String get swapDetails {
    return Intl.message(
      'Swap Details',
      name: 'swapDetails',
      desc: '',
      args: [],
    );
  }

  /// `Max Swap Percentage`
  String get maxSwapPercentage {
    return Intl.message(
      'Max Swap Percentage',
      name: 'maxSwapPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Max swap percentage per token`
  String get maxSwapPercentagePerToken {
    return Intl.message(
      'Max swap percentage per token',
      name: 'maxSwapPercentagePerToken',
      desc: '',
      args: [],
    );
  }

  /// `Slippage`
  String get slippage {
    return Intl.message('Slippage', name: 'slippage', desc: '', args: []);
  }

  /// `Custom`
  String get custom {
    return Intl.message('Custom', name: 'custom', desc: '', args: []);
  }

  /// `Your transaction will fail if the price changes more than the slippage. Too high of a value will result in an unfavorable trade.`
  String get yourTransactionWillFailIfThePriceChangesMoreThan {
    return Intl.message(
      'Your transaction will fail if the price changes more than the slippage. Too high of a value will result in an unfavorable trade.',
      name: 'yourTransactionWillFailIfThePriceChangesMoreThan',
      desc: '',
      args: [],
    );
  }

  /// `The percentage of money in your wallet that allowed to perform swap Swap will fail if the swapped  amount exceed the allowed percentage`
  String get thePercentageOfMoneyInYourWalletThatAllowedTo {
    return Intl.message(
      'The percentage of money in your wallet that allowed to perform swap Swap will fail if the swapped  amount exceed the allowed percentage',
      name: 'thePercentageOfMoneyInYourWalletThatAllowedTo',
      desc: '',
      args: [],
    );
  }

  /// `where milliseconds matter and markets shift in the blink of an eye, powered trading Bot X is revolutionizing how to manage digital assets`
  String get whereMillisecondsMatterAndMarketsShiftInTheBlinkOf {
    return Intl.message(
      'where milliseconds matter and markets shift in the blink of an eye, powered trading Bot X is revolutionizing how to manage digital assets',
      name: 'whereMillisecondsMatterAndMarketsShiftInTheBlinkOf',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Bot X,`
  String get welcomeToBotX {
    return Intl.message(
      'Welcome to Bot X,',
      name: 'welcomeToBotX',
      desc: '',
      args: [],
    );
  }

  /// `Next-Generation AI Trading Bot X`
  String get nextgenerationAiTradingBotX {
    return Intl.message(
      'Next-Generation AI Trading Bot X',
      name: 'nextgenerationAiTradingBotX',
      desc: '',
      args: [],
    );
  }

  /// `Add wallet`
  String get addWallet {
    return Intl.message('Add wallet', name: 'addWallet', desc: '', args: []);
  }

  /// `Transfer Details`
  String get transferDetails {
    return Intl.message(
      'Transfer Details',
      name: 'transferDetails',
      desc: '',
      args: [],
    );
  }

  /// `Text copied to clipboard`
  String get textCopiedToClipboard {
    return Intl.message(
      'Text copied to clipboard',
      name: 'textCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `your following`
  String get yourFollowing {
    return Intl.message(
      'your following',
      name: 'yourFollowing',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get manual {
    return Intl.message('Manual', name: 'manual', desc: '', args: []);
  }

  /// `Auto`
  String get auto {
    return Intl.message('Auto', name: 'auto', desc: '', args: []);
  }

  /// `end`
  String get end {
    return Intl.message('end', name: 'end', desc: '', args: []);
  }

  /// `Slippage Scaler`
  String get slippageScaler {
    return Intl.message(
      'Slippage Scaler',
      name: 'slippageScaler',
      desc: '',
      args: [],
    );
  }

  /// `MSP per Token`
  String get mspPerToken {
    return Intl.message(
      'MSP per Token',
      name: 'mspPerToken',
      desc: '',
      args: [],
    );
  }

  /// `MSP`
  String get msp {
    return Intl.message('MSP', name: 'msp', desc: '', args: []);
  }

  /// `The Bot X bot will do the swaps for you`
  String get theBotXBotWillDoTheSwapsForYou {
    return Intl.message(
      'The Bot X bot will do the swaps for you',
      name: 'theBotXBotWillDoTheSwapsForYou',
      desc: '',
      args: [],
    );
  }

  /// `Swapped`
  String get swapped {
    return Intl.message('Swapped', name: 'swapped', desc: '', args: []);
  }

  /// `AI Suggest`
  String get aiSuggest {
    return Intl.message('AI Suggest', name: 'aiSuggest', desc: '', args: []);
  }

  /// `Enjoy Bot X Will Trading Now`
  String get enjoyBotXWillTradingNow {
    return Intl.message(
      'Enjoy Bot X Will Trading Now',
      name: 'enjoyBotXWillTradingNow',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Swap Now`
  String get swapNow {
    return Intl.message('Swap Now', name: 'swapNow', desc: '', args: []);
  }

  /// `AI Analysis`
  String get aiAnalysis {
    return Intl.message('AI Analysis', name: 'aiAnalysis', desc: '', args: []);
  }

  /// `summary`
  String get summary {
    return Intl.message('summary', name: 'summary', desc: '', args: []);
  }

  /// `Market Cap`
  String get marketCap {
    return Intl.message('Market Cap', name: 'marketCap', desc: '', args: []);
  }

  /// `liquidity`
  String get liquidity {
    return Intl.message('liquidity', name: 'liquidity', desc: '', args: []);
  }

  /// `Final recommendation`
  String get finalRecommendation {
    return Intl.message(
      'Final recommendation',
      name: 'finalRecommendation',
      desc: '',
      args: [],
    );
  }

  /// `Bullish`
  String get bullish {
    return Intl.message('Bullish', name: 'bullish', desc: '', args: []);
  }

  /// `Bearish`
  String get bearish {
    return Intl.message('Bearish', name: 'bearish', desc: '', args: []);
  }

  /// `Recommendation`
  String get recommendation {
    return Intl.message(
      'Recommendation',
      name: 'recommendation',
      desc: '',
      args: [],
    );
  }

  /// `Short term`
  String get shortTerm {
    return Intl.message('Short term', name: 'shortTerm', desc: '', args: []);
  }

  /// `Medium term`
  String get mediumTerm {
    return Intl.message('Medium term', name: 'mediumTerm', desc: '', args: []);
  }

  /// `volume`
  String get volume {
    return Intl.message('volume', name: 'volume', desc: '', args: []);
  }

  /// `Long term`
  String get longTerm {
    return Intl.message('Long term', name: 'longTerm', desc: '', args: []);
  }

  /// `Add KOL wallet`
  String get addKolWallet {
    return Intl.message(
      'Add KOL wallet',
      name: 'addKolWallet',
      desc: '',
      args: [],
    );
  }

  /// `Sentiment Analyses`
  String get sentimentAnalyses {
    return Intl.message(
      'Sentiment Analyses',
      name: 'sentimentAnalyses',
      desc: '',
      args: [],
    );
  }

  /// `Statistical analyses`
  String get statisticalAnalyses {
    return Intl.message(
      'Statistical analyses',
      name: 'statisticalAnalyses',
      desc: '',
      args: [],
    );
  }

  /// `Copy address`
  String get copyAddress {
    return Intl.message(
      'Copy address',
      name: 'copyAddress',
      desc: '',
      args: [],
    );
  }

  /// `marks`
  String get marks {
    return Intl.message('marks', name: 'marks', desc: '', args: []);
  }

  /// `Absence`
  String get absence {
    return Intl.message('Absence', name: 'absence', desc: '', args: []);
  }

  /// `News`
  String get news {
    return Intl.message('News', name: 'news', desc: '', args: []);
  }

  /// `Links`
  String get links {
    return Intl.message('Links', name: 'links', desc: '', args: []);
  }

  /// `Week Schedule`
  String get weekSchedule {
    return Intl.message(
      'Week Schedule',
      name: 'weekSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Exam Schedule`
  String get examSchedule {
    return Intl.message(
      'Exam Schedule',
      name: 'examSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `To change your account`
  String get toChangeYourAccount {
    return Intl.message(
      'To change your account',
      name: 'toChangeYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `buildNumber`
  String get buildnumber {
    return Intl.message('buildNumber', name: 'buildnumber', desc: '', args: []);
  }

  /// `Exam Score`
  String get examScore {
    return Intl.message('Exam Score', name: 'examScore', desc: '', args: []);
  }

  /// `Class`
  String get className {
    return Intl.message('Class', name: 'className', desc: '', args: []);
  }

  /// `Academic Year`
  String get academicYear {
    return Intl.message(
      'Academic Year',
      name: 'academicYear',
      desc: '',
      args: [],
    );
  }

  /// `Change student`
  String get changeStudent {
    return Intl.message(
      'Change student',
      name: 'changeStudent',
      desc: '',
      args: [],
    );
  }

  /// `Subjects`
  String get subjects {
    return Intl.message('Subjects', name: 'subjects', desc: '', args: []);
  }

  /// `Exams`
  String get exams {
    return Intl.message('Exams', name: 'exams', desc: '', args: []);
  }

  /// `Section`
  String get section {
    return Intl.message('Section', name: 'section', desc: '', args: []);
  }

  /// `Daily Academic Follow-up`
  String get dailyAcademicFollowup {
    return Intl.message(
      'Daily Academic Follow-up',
      name: 'dailyAcademicFollowup',
      desc: '',
      args: [],
    );
  }

  /// `Track students’ daily academic progress and record their learning updates.`
  String get trackStudentsDailyAcademicProgressAndRecordTheirLearningUpdates {
    return Intl.message(
      'Track students’ daily academic progress and record their learning updates.',
      name: 'trackStudentsDailyAcademicProgressAndRecordTheirLearningUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Record Academic Follow-up`
  String get recordAcademicFollowup {
    return Intl.message(
      'Record Academic Follow-up',
      name: 'recordAcademicFollowup',
      desc: '',
      args: [],
    );
  }

  /// `Add Educational followup`
  String get addEducationalFollowup {
    return Intl.message(
      'Add Educational followup',
      name: 'addEducationalFollowup',
      desc: '',
      args: [],
    );
  }

  /// `Add your note hear...`
  String get addYourNoteHear {
    return Intl.message(
      'Add your note hear...',
      name: 'addYourNoteHear',
      desc: '',
      args: [],
    );
  }

  /// `Latest Add`
  String get latestAdd {
    return Intl.message('Latest Add', name: 'latestAdd', desc: '', args: []);
  }

  /// `Add Remark`
  String get addRemark {
    return Intl.message('Add Remark', name: 'addRemark', desc: '', args: []);
  }

  /// `Select Semester`
  String get selectSemester {
    return Intl.message(
      'Select Semester',
      name: 'selectSemester',
      desc: '',
      args: [],
    );
  }

  /// `Behavioral Notes for Today`
  String get behavioralNotesForToday {
    return Intl.message(
      'Behavioral Notes for Today',
      name: 'behavioralNotesForToday',
      desc: '',
      args: [],
    );
  }

  /// `Document students’ daily behavior and maintain a record of observations.`
  String get documentStudentsDailyBehaviorAndMaintainARecordOfObservations {
    return Intl.message(
      'Document students’ daily behavior and maintain a record of observations.',
      name: 'documentStudentsDailyBehaviorAndMaintainARecordOfObservations',
      desc: '',
      args: [],
    );
  }

  /// `Record Behavioral Notes`
  String get recordBehavioralNotes {
    return Intl.message(
      'Record Behavioral Notes',
      name: 'recordBehavioralNotes',
      desc: '',
      args: [],
    );
  }

  /// `Semester`
  String get semester {
    return Intl.message('Semester', name: 'semester', desc: '', args: []);
  }

  /// `Remark type`
  String get remarkType {
    return Intl.message('Remark type', name: 'remarkType', desc: '', args: []);
  }

  /// `Exam Grades`
  String get examGrades {
    return Intl.message('Exam Grades', name: 'examGrades', desc: '', args: []);
  }

  /// `Manage and update students’ exam results and performance reports.`
  String get manageAndUpdateStudentsExamResultsAndPerformanceReports {
    return Intl.message(
      'Manage and update students’ exam results and performance reports.',
      name: 'manageAndUpdateStudentsExamResultsAndPerformanceReports',
      desc: '',
      args: [],
    );
  }

  /// `Record Grades`
  String get recordGrades {
    return Intl.message(
      'Record Grades',
      name: 'recordGrades',
      desc: '',
      args: [],
    );
  }

  /// `Select Assessment`
  String get selectAssessment {
    return Intl.message(
      'Select Assessment',
      name: 'selectAssessment',
      desc: '',
      args: [],
    );
  }

  /// `Rewords`
  String get rewords {
    return Intl.message('Rewords', name: 'rewords', desc: '', args: []);
  }

  /// `Educational followup`
  String get educationalFollowup {
    return Intl.message(
      'Educational followup',
      name: 'educationalFollowup',
      desc: '',
      args: [],
    );
  }

  /// `Institution notes`
  String get institutionNotes {
    return Intl.message(
      'Institution notes',
      name: 'institutionNotes',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message('Follow', name: 'follow', desc: '', args: []);
  }

  /// `First semester`
  String get firstSemester {
    return Intl.message(
      'First semester',
      name: 'firstSemester',
      desc: '',
      args: [],
    );
  }

  /// `Second semester`
  String get secondSemester {
    return Intl.message(
      'Second semester',
      name: 'secondSemester',
      desc: '',
      args: [],
    );
  }

  /// `january`
  String get january {
    return Intl.message('january', name: 'january', desc: '', args: []);
  }

  /// `february`
  String get february {
    return Intl.message('february', name: 'february', desc: '', args: []);
  }

  /// `march`
  String get march {
    return Intl.message('march', name: 'march', desc: '', args: []);
  }

  /// `april`
  String get april {
    return Intl.message('april', name: 'april', desc: '', args: []);
  }

  /// `may`
  String get may {
    return Intl.message('may', name: 'may', desc: '', args: []);
  }

  /// `june`
  String get june {
    return Intl.message('june', name: 'june', desc: '', args: []);
  }

  /// `july`
  String get july {
    return Intl.message('july', name: 'july', desc: '', args: []);
  }

  /// `august`
  String get august {
    return Intl.message('august', name: 'august', desc: '', args: []);
  }

  /// `september`
  String get september {
    return Intl.message('september', name: 'september', desc: '', args: []);
  }

  /// `october`
  String get october {
    return Intl.message('october', name: 'october', desc: '', args: []);
  }

  /// `november`
  String get november {
    return Intl.message('november', name: 'november', desc: '', args: []);
  }

  /// `december`
  String get december {
    return Intl.message('december', name: 'december', desc: '', args: []);
  }

  /// `Final result`
  String get finalResult {
    return Intl.message(
      'Final result',
      name: 'finalResult',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message('Rank', name: 'rank', desc: '', args: []);
  }

  /// `Score card`
  String get scoreCard {
    return Intl.message('Score card', name: 'scoreCard', desc: '', args: []);
  }

  /// `justified`
  String get justified {
    return Intl.message('justified', name: 'justified', desc: '', args: []);
  }

  /// `unjustified`
  String get unjustified {
    return Intl.message('unjustified', name: 'unjustified', desc: '', args: []);
  }

  /// `Show as List`
  String get showAsList {
    return Intl.message('Show as List', name: 'showAsList', desc: '', args: []);
  }

  /// `No marks found for this semester`
  String get noMarksFoundForThisSemester {
    return Intl.message(
      'No marks found for this semester',
      name: 'noMarksFoundForThisSemester',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get ended {
    return Intl.message('Ended', name: 'ended', desc: '', args: []);
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Add Marks`
  String get addMarks {
    return Intl.message('Add Marks', name: 'addMarks', desc: '', args: []);
  }

  /// `Time / Day`
  String get timeDay {
    return Intl.message('Time / Day', name: 'timeDay', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `calendar`
  String get calendar {
    return Intl.message('calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Login to ...`
  String get loginTo {
    return Intl.message('Login to ...', name: 'loginTo', desc: '', args: []);
  }

  /// `Basic Information`
  String get basicInformation {
    return Intl.message(
      'Basic Information',
      name: 'basicInformation',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `National Number`
  String get nationalNumber {
    return Intl.message(
      'National Number',
      name: 'nationalNumber',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Place of Birth`
  String get placeOfBirth {
    return Intl.message(
      'Place of Birth',
      name: 'placeOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get family {
    return Intl.message('Family', name: 'family', desc: '', args: []);
  }

  /// `Father`
  String get father {
    return Intl.message('Father', name: 'father', desc: '', args: []);
  }

  /// `Mother`
  String get mother {
    return Intl.message('Mother', name: 'mother', desc: '', args: []);
  }

  /// `Grandfather`
  String get grandfather {
    return Intl.message('Grandfather', name: 'grandfather', desc: '', args: []);
  }

  /// `School`
  String get school {
    return Intl.message('School', name: 'school', desc: '', args: []);
  }

  /// `Registration Number`
  String get registrationNumber {
    return Intl.message(
      'Registration Number',
      name: 'registrationNumber',
      desc: '',
      args: [],
    );
  }

  /// `Old School`
  String get oldSchool {
    return Intl.message('Old School', name: 'oldSchool', desc: '', args: []);
  }

  /// `New School`
  String get newSchool {
    return Intl.message('New School', name: 'newSchool', desc: '', args: []);
  }

  /// `Joining Date`
  String get joiningDate {
    return Intl.message(
      'Joining Date',
      name: 'joiningDate',
      desc: '',
      args: [],
    );
  }

  /// `Home Phone`
  String get homePhone {
    return Intl.message('Home Phone', name: 'homePhone', desc: '', args: []);
  }

  /// `Student Phone`
  String get studentPhone {
    return Intl.message(
      'Student Phone',
      name: 'studentPhone',
      desc: '',
      args: [],
    );
  }

  /// `Academic Status`
  String get academicStatus {
    return Intl.message(
      'Academic Status',
      name: 'academicStatus',
      desc: '',
      args: [],
    );
  }

  /// `Student Status`
  String get studentStatus {
    return Intl.message(
      'Student Status',
      name: 'studentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Next Year Status`
  String get nextYearStatus {
    return Intl.message(
      'Next Year Status',
      name: 'nextYearStatus',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get blocked {
    return Intl.message('Blocked', name: 'blocked', desc: '', args: []);
  }

  /// `Entitlements`
  String get entitlements {
    return Intl.message(
      'Entitlements',
      name: 'entitlements',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get payments {
    return Intl.message('Payments', name: 'payments', desc: '', args: []);
  }

  /// `Account statement`
  String get accountStatement {
    return Intl.message(
      'Account statement',
      name: 'accountStatement',
      desc: '',
      args: [],
    );
  }

  /// `Banks`
  String get banks {
    return Intl.message('Banks', name: 'banks', desc: '', args: []);
  }

  /// `Register Courses`
  String get registerCourses {
    return Intl.message(
      'Register Courses',
      name: 'registerCourses',
      desc: '',
      args: [],
    );
  }

  /// `Current Semester Marks`
  String get currentSemesterMarks {
    return Intl.message(
      'Current Semester Marks',
      name: 'currentSemesterMarks',
      desc: '',
      args: [],
    );
  }

  /// `Theoretical`
  String get theoretical {
    return Intl.message('Theoretical', name: 'theoretical', desc: '', args: []);
  }

  /// `Practical`
  String get practical {
    return Intl.message('Practical', name: 'practical', desc: '', args: []);
  }

  /// `Academic Record`
  String get academicRecord {
    return Intl.message(
      'Academic Record',
      name: 'academicRecord',
      desc: '',
      args: [],
    );
  }

  /// `Chosen`
  String get chosen {
    return Intl.message('Chosen', name: 'chosen', desc: '', args: []);
  }

  /// `Table info`
  String get tableInfo {
    return Intl.message('Table info', name: 'tableInfo', desc: '', args: []);
  }

  /// `Chosen hours count`
  String get chosenHoursCount {
    return Intl.message(
      'Chosen hours count',
      name: 'chosenHoursCount',
      desc: '',
      args: [],
    );
  }

  /// `At least`
  String get atLeast {
    return Intl.message('At least', name: 'atLeast', desc: '', args: []);
  }

  /// `SPY`
  String get syp {
    return Intl.message('SPY', name: 'syp', desc: '', args: []);
  }

  /// `USD`
  String get usd {
    return Intl.message('USD', name: 'usd', desc: '', args: []);
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `id`
  String get id {
    return Intl.message('id', name: 'id', desc: '', args: []);
  }

  /// `Payment date`
  String get paymentDate {
    return Intl.message(
      'Payment date',
      name: 'paymentDate',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get accountNumber {
    return Intl.message(
      'Account number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `BankName`
  String get bankName {
    return Intl.message('BankName', name: 'bankName', desc: '', args: []);
  }

  /// `submitted`
  String get submitted {
    return Intl.message('submitted', name: 'submitted', desc: '', args: []);
  }

  /// `inProgress`
  String get inProgress {
    return Intl.message('inProgress', name: 'inProgress', desc: '', args: []);
  }

  /// `rejected`
  String get rejected {
    return Intl.message('rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Request`
  String get request {
    return Intl.message('Request', name: 'request', desc: '', args: []);
  }

  /// `Dues`
  String get dues {
    return Intl.message('Dues', name: 'dues', desc: '', args: []);
  }

  /// `Swift Code`
  String get swiftCode {
    return Intl.message('Swift Code', name: 'swiftCode', desc: '', args: []);
  }

  /// `Financial Event`
  String get financialEvent {
    return Intl.message(
      'Financial Event',
      name: 'financialEvent',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw from course`
  String get withdrawFromCourse {
    return Intl.message(
      'Withdraw from course',
      name: 'withdrawFromCourse',
      desc: '',
      args: [],
    );
  }

  /// `Course mark`
  String get courseMark {
    return Intl.message('Course mark', name: 'courseMark', desc: '', args: []);
  }

  /// `Term Name`
  String get termName {
    return Intl.message('Term Name', name: 'termName', desc: '', args: []);
  }

  /// `Academic Program Name`
  String get academicProgramName {
    return Intl.message(
      'Academic Program Name',
      name: 'academicProgramName',
      desc: '',
      args: [],
    );
  }

  /// `Registration Type`
  String get registrationType {
    return Intl.message(
      'Registration Type',
      name: 'registrationType',
      desc: '',
      args: [],
    );
  }

  /// `GPA`
  String get gpa {
    return Intl.message('GPA', name: 'gpa', desc: '', args: []);
  }

  /// `Accumulative GPA`
  String get accumulativeGpa {
    return Intl.message(
      'Accumulative GPA',
      name: 'accumulativeGpa',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message('Level', name: 'level', desc: '', args: []);
  }

  /// `Student record status`
  String get studentRecordStatus {
    return Intl.message(
      'Student record status',
      name: 'studentRecordStatus',
      desc: '',
      args: [],
    );
  }

  /// `Registered credit hour`
  String get registeredCreditHour {
    return Intl.message(
      'Registered credit hour',
      name: 'registeredCreditHour',
      desc: '',
      args: [],
    );
  }

  /// `Passed credit hour`
  String get passedCreditHour {
    return Intl.message(
      'Passed credit hour',
      name: 'passedCreditHour',
      desc: '',
      args: [],
    );
  }

  /// `Current Semester Courses`
  String get currentSemesterCourses {
    return Intl.message(
      'Current Semester Courses',
      name: 'currentSemesterCourses',
      desc: '',
      args: [],
    );
  }

  /// `At most`
  String get atMost {
    return Intl.message('At most', name: 'atMost', desc: '', args: []);
  }

  /// `Start of year`
  String get startOfYear {
    return Intl.message(
      'Start of year',
      name: 'startOfYear',
      desc: '',
      args: [],
    );
  }

  /// `Before midterm exam`
  String get beforeMidtermExam {
    return Intl.message(
      'Before midterm exam',
      name: 'beforeMidtermExam',
      desc: '',
      args: [],
    );
  }

  /// `Before final exam`
  String get beforeFinalExam {
    return Intl.message(
      'Before final exam',
      name: 'beforeFinalExam',
      desc: '',
      args: [],
    );
  }

  /// `Registered`
  String get registered {
    return Intl.message('Registered', name: 'registered', desc: '', args: []);
  }

  /// `Unregistered`
  String get unregistered {
    return Intl.message(
      'Unregistered',
      name: 'unregistered',
      desc: '',
      args: [],
    );
  }

  /// `Agenda`
  String get agenda {
    return Intl.message('Agenda', name: 'agenda', desc: '', args: []);
  }

  /// `Schedule`
  String get schedule {
    return Intl.message('Schedule', name: 'schedule', desc: '', args: []);
  }

  /// `Exam`
  String get exam {
    return Intl.message('Exam', name: 'exam', desc: '', args: []);
  }

  /// `Withdrawal`
  String get withdrawal {
    return Intl.message('Withdrawal', name: 'withdrawal', desc: '', args: []);
  }

  /// `Agenda name`
  String get agendaName {
    return Intl.message('Agenda name', name: 'agendaName', desc: '', args: []);
  }

  /// `Capacity`
  String get capacity {
    return Intl.message('Capacity', name: 'capacity', desc: '', args: []);
  }

  /// `Mid`
  String get mid {
    return Intl.message('Mid', name: 'mid', desc: '', args: []);
  }

  /// `Final`
  String get finalExam {
    return Intl.message('Final', name: 'finalExam', desc: '', args: []);
  }

  /// `Direct`
  String get direct {
    return Intl.message('Direct', name: 'direct', desc: '', args: []);
  }

  /// `General competition`
  String get generalCompetition {
    return Intl.message(
      'General competition',
      name: 'generalCompetition',
      desc: '',
      args: [],
    );
  }

  /// `Filling places competition`
  String get fillingPlacesCompetition {
    return Intl.message(
      'Filling places competition',
      name: 'fillingPlacesCompetition',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Your Rank`
  String get yourRank {
    return Intl.message('Your Rank', name: 'yourRank', desc: '', args: []);
  }

  /// `All Students`
  String get allStudentsRank {
    return Intl.message(
      'All Students',
      name: 'allStudentsRank',
      desc: '',
      args: [],
    );
  }

  /// `Higher Than You`
  String get higherThanYou {
    return Intl.message(
      'Higher Than You',
      name: 'higherThanYou',
      desc: '',
      args: [],
    );
  }

  /// `Lower Than You`
  String get lowerThanYou {
    return Intl.message(
      'Lower Than You',
      name: 'lowerThanYou',
      desc: '',
      args: [],
    );
  }

  /// `Add Order`
  String get addOrder {
    return Intl.message('Add Order', name: 'addOrder', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
