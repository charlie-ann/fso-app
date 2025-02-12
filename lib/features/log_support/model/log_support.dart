// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:equatable/equatable.dart';

class LogSupportParams extends Equatable {
  LogSupportParams({
    this.taskId,
    this.terminalId,
    this.supportType,
    this.purpose,
    this.lat,
    this.lng,
    this.merchantName,
    this.phoneNumber,
    this.state,
    this.businessType,
    this.network,
    this.simSerial,
    this.type,
    this.appVersion,
    this.serialNumber,
    this.signature,
    this.document,
    this.logType,
    this.scanDate,
    this.scanTime,
    this.supportStatus,
    this.address,
    this.fsoId,
    this.bankName,
    this.area,
    this.uniformReport,
    this.others,
  });
  int? taskId;
  String? terminalId;
  String? supportType;
  String? purpose;
  String? lat;
  String? lng;
  String? merchantName;
  String? phoneNumber;
  String? state;
  String? businessType;
  String? network;
  String? simSerial;
  String? type;
  String? appVersion;
  String? serialNumber;
  File? signature;
  List<File>? document;
  String? logType;
  String? scanDate;
  String? scanTime;
  String? supportStatus;
  String? address;
  String? fsoId;
  String? bankName;
  String? area;
  String? uniformReport;
  String? others;

  @override
  List<Object?> get props => [
        taskId,
        terminalId,
        supportType,
        purpose,
        lat,
        lng,
        merchantName,
        phoneNumber,
        state,
        businessType,
        network,
        simSerial,
        type,
        appVersion,
        serialNumber,
        signature,
        document,
        logType,
        scanDate,
        scanTime,
        supportStatus,
        address,
        fsoId,
        bankName,
        area,
        uniformReport,
        others
      ];
  LogSupportParams copyWith(
      {int? taskId,
      String? terminalId,
      String? supportType,
      String? purpose,
      String? lat,
      String? lng,
      String? merchantName,
      String? phoneNumber,
      String? state,
      String? businessType,
      String? network,
      String? simSerial,
      String? type,
      String? appVersion,
      String? serialNumber,
      File? signature,
      List<File>? document,
      String? logType,
      String? scanDate,
      String? scanTime,
      String? supportStatus,
      String? address,
      String? fsoId,
      String? bankName,
      String? area,
      String? uniformReport,
      String? others}) {
    return LogSupportParams(
      taskId: taskId ?? this.taskId,
      terminalId: terminalId ?? this.terminalId,
      supportType: supportType ?? this.supportType,
      purpose: purpose ?? this.purpose,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      merchantName: merchantName ?? this.merchantName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      state: state ?? this.state,
      businessType: businessType ?? this.businessType,
      network: network ?? this.network,
      simSerial: simSerial ?? this.simSerial,
      type: type ?? this.type,
      appVersion: appVersion ?? this.appVersion,
      serialNumber: serialNumber ?? this.serialNumber,
      signature: signature ?? this.signature,
      document: document ?? this.document,
      logType: logType ?? this.logType,
      scanDate: scanDate ?? this.scanDate,
      scanTime: scanTime ?? this.scanTime,
      supportStatus: supportStatus ?? this.supportStatus,
      address: address ?? this.address,
      fsoId: fsoId ?? this.fsoId,
      bankName: bankName ?? this.bankName,
      area: area ?? this.area,
      uniformReport: uniformReport ?? this.uniformReport,
      others: others ?? this.others,
    );
  }

  // function to clear
  LogSupportParams clear() {
    return LogSupportParams(
        taskId: null,
        terminalId: null,
        supportType: null,
        purpose: null,
        lat: null,
        lng: null,
        merchantName: null,
        phoneNumber: null,
        state: null,
        businessType: null,
        network: null,
        simSerial: null,
        type: null,
        appVersion: null,
        serialNumber: null,
        signature: null,
        document: null,
        logType: null,
        scanDate: null,
        scanTime: null,
        supportStatus: null,
        address: null,
        fsoId: null,
        bankName: null,
        area: null,
        uniformReport: null,
        others: null);
  }
}
