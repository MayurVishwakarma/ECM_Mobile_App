class ECMStatusCountMasterModel {
  int? sCount;
  int? pendingMechanical;
  int? partiallyMechanical;
  int? fullyMechanical;
  int? rejectedMechanical;
  int? fullyApprovedMechanical;
  int? pendingErection;
  int? partiallyErection;
  int? fullyErection;
  int? rejectedErection;
  int? fullyApprovedErection;
  int? pendingDryComm;
  int? fullyDryComm;
  int? partiallyDryComm;
  int? fullyApprovedDryComm;
  int? rejectedDryComm;
  int? pendingWetComm;
  int? partiallyWetComm;
  int? fullyWetComm;
  int? fullyApprovedWetComm;
  int? rejectedWetComm;
  int? pendingAutoDryComm;
  int? fullyAutoDryComm;
  int? partiallyAutoDryComm;
  int? fullyApprovedAutoDryComm;
  int? rejectedAutoDryComm;
  int? pendingAutoWetComm;
  int? fullyAutoWetComm;
  int? partiallyAutoWetComm;
  int? fullyApprovedAutoWetComm;
  int? rejectedAutoWetComm;
  int? pendingTrenching;
  int? partiallyTrenching;
  int? fullyTrenching;
  int? rejectedTrenching;
  int? fullyApprovedTrenching;
  int? pendingPipeInstallation;
  int? partiallyPipeInstallation;
  int? fullyPipeInstallation;
  int? rejectedPipeInstallation;
  int? fullyApprovedPipeInstallation;
  int? pendingProcess1;
  int? partiallyProcess1;
  int? fullyProcess1;
  int? rejectedProcess1;
  int? fullyApprovedProcess1;
  int? pendingProcess2;
  int? partiallyProcess2;
  int? fullyProcess2;
  int? rejectedProcess2;
  int? fullyApprovedProcess2;
  int? pendingProcess3;
  int? fullyProcess3;
  int? partiallyProcess3;
  int? fullyApprovedProcess3;
  int? rejectedProcess3;
  int? pendingProcess4;
  int? partiallyProcess4;
  int? fullyProcess4;
  int? fullyApprovedProcess4;
  int? rejectedProcess4;
  int? pendingProcess5;
  int? partiallyProcess5;
  int? fullyProcess5;
  int? fullyApprovedProcess5;
  int? rejectedProcess5;
  int? pendingProcess6;
  int? partiallyProcess6;
  int? fullyProcess6;
  int? fullyApprovedProcess6;
  int? rejectedProcess6;

  ECMStatusCountMasterModel(
      {this.sCount,
      this.pendingMechanical,
      this.partiallyMechanical,
      this.fullyMechanical,
      this.rejectedMechanical,
      this.fullyApprovedMechanical,
      this.pendingErection,
      this.partiallyErection,
      this.fullyErection,
      this.rejectedErection,
      this.fullyApprovedErection,
      this.pendingDryComm,
      this.fullyDryComm,
      this.partiallyDryComm,
      this.fullyApprovedDryComm,
      this.rejectedDryComm,
      this.pendingWetComm,
      this.partiallyWetComm,
      this.fullyWetComm,
      this.fullyApprovedWetComm,
      this.rejectedWetComm,
      this.pendingAutoDryComm,
      this.fullyAutoDryComm,
      this.partiallyAutoDryComm,
      this.fullyApprovedAutoDryComm,
      this.rejectedAutoDryComm,
      this.pendingAutoWetComm,
      this.fullyAutoWetComm,
      this.partiallyAutoWetComm,
      this.fullyApprovedAutoWetComm,
      this.rejectedAutoWetComm,
      this.pendingTrenching,
      this.partiallyTrenching,
      this.fullyTrenching,
      this.rejectedTrenching,
      this.fullyApprovedTrenching,
      this.pendingPipeInstallation,
      this.partiallyPipeInstallation,
      this.fullyPipeInstallation,
      this.rejectedPipeInstallation,
      this.fullyApprovedPipeInstallation,
      this.pendingProcess1,
      this.partiallyProcess1,
      this.fullyProcess1,
      this.rejectedProcess1,
      this.fullyApprovedProcess1,
      this.pendingProcess2,
      this.partiallyProcess2,
      this.fullyProcess2,
      this.rejectedProcess2,
      this.fullyApprovedProcess2,
      this.pendingProcess3,
      this.fullyProcess3,
      this.partiallyProcess3,
      this.fullyApprovedProcess3,
      this.rejectedProcess3,
      this.pendingProcess4,
      this.partiallyProcess4,
      this.fullyProcess4,
      this.fullyApprovedProcess4,
      this.rejectedProcess4,
      this.pendingProcess5,
      this.partiallyProcess5,
      this.fullyProcess5,
      this.fullyApprovedProcess5,
      this.rejectedProcess5,
      this.pendingProcess6,
      this.partiallyProcess6,
      this.fullyProcess6,
      this.fullyApprovedProcess6,
      this.rejectedProcess6});

  ECMStatusCountMasterModel.fromJson(Map<String, dynamic> json) {
    sCount = json['SCount'];
    pendingMechanical = json['PendingMechanical'];
    partiallyMechanical = json['PartiallyMechanical'];
    fullyMechanical = json['FullyMechanical'];
    rejectedMechanical = json['RejectedMechanical'];
    fullyApprovedMechanical = json['FullyApprovedMechanical'];
    pendingErection = json['PendingErection'];
    partiallyErection = json['PartiallyErection'];
    fullyErection = json['FullyErection'];
    rejectedErection = json['RejectedErection'];
    fullyApprovedErection = json['FullyApprovedErection'];
    pendingDryComm = json['PendingDryComm'];
    fullyDryComm = json['FullyDryComm'];
    partiallyDryComm = json['PartiallyDryComm'];
    fullyApprovedDryComm = json['FullyApprovedDryComm'];
    rejectedDryComm = json['RejectedDryComm'];
    pendingWetComm = json['PendingWetComm'];
    partiallyWetComm = json['PartiallyWetComm'];
    fullyWetComm = json['FullyWetComm'];
    fullyApprovedWetComm = json['FullyApprovedWetComm'];
    rejectedWetComm = json['RejectedWetComm'];
    pendingAutoDryComm = json['PendingAutoDryComm'];
    fullyAutoDryComm = json['FullyAutoDryComm'];
    partiallyAutoDryComm = json['PartiallyAutoDryComm'];
    fullyApprovedAutoDryComm = json['FullyApprovedAutoDryComm'];
    rejectedAutoDryComm = json['RejectedAutoDryComm'];
    pendingAutoWetComm = json['PendingAutoWetComm'];
    fullyAutoWetComm = json['FullyAutoWetComm'];
    partiallyAutoWetComm = json['PartiallyAutoWetComm'];
    fullyApprovedAutoWetComm = json['FullyApprovedAutoWetComm'];
    rejectedAutoWetComm = json['RejectedAutoWetComm'];
    pendingTrenching = json['PendingTrenching'];
    partiallyTrenching = json['PartiallyTrenching'];
    fullyTrenching = json['FullyTrenching'];
    rejectedTrenching = json['RejectedTrenching'];
    fullyApprovedTrenching = json['FullyApprovedTrenching'];
    pendingPipeInstallation = json['PendingPipeInstallation'];
    partiallyPipeInstallation = json['PartiallyPipeInstallation'];
    fullyPipeInstallation = json['FullyPipeInstallation'];
    rejectedPipeInstallation = json['RejectedPipeInstallation'];
    fullyApprovedPipeInstallation = json['FullyApprovedPipeInstallation'];
    pendingProcess1 = json['PendingProcess1'];
    partiallyProcess1 = json['PartiallyProcess1'];
    fullyProcess1 = json['FullyProcess1'];
    rejectedProcess1 = json['RejectedProcess1'];
    fullyApprovedProcess1 = json['FullyApprovedProcess1'];
    pendingProcess2 = json['PendingProcess2'];
    partiallyProcess2 = json['PartiallyProcess2'];
    fullyProcess2 = json['FullyProcess2'];
    rejectedProcess2 = json['RejectedProcess2'];
    fullyApprovedProcess2 = json['FullyApprovedProcess2'];
    pendingProcess3 = json['PendingProcess3'];
    fullyProcess3 = json['FullyProcess3'];
    partiallyProcess3 = json['PartiallyProcess3'];
    fullyApprovedProcess3 = json['FullyApprovedProcess3'];
    rejectedProcess3 = json['RejectedProcess3'];
    pendingProcess4 = json['PendingProcess4'];
    partiallyProcess4 = json['PartiallyProcess4'];
    fullyProcess4 = json['FullyProcess4'];
    fullyApprovedProcess4 = json['FullyApprovedProcess4'];
    rejectedProcess4 = json['RejectedProcess4'];
    pendingProcess5 = json['PendingProcess5'];
    partiallyProcess5 = json['PartiallyProcess5'];
    fullyProcess5 = json['FullyProcess5'];
    fullyApprovedProcess5 = json['FullyApprovedProcess5'];
    rejectedProcess5 = json['RejectedProcess5'];
    pendingProcess6 = json['PendingProcess6'];
    partiallyProcess6 = json['PartiallyProcess6'];
    fullyProcess6 = json['FullyProcess6'];
    fullyApprovedProcess6 = json['FullyApprovedProcess6'];
    rejectedProcess6 = json['RejectedProcess6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SCount'] = this.sCount;
    data['PendingMechanical'] = this.pendingMechanical;
    data['PartiallyMechanical'] = this.partiallyMechanical;
    data['FullyMechanical'] = this.fullyMechanical;
    data['RejectedMechanical'] = this.rejectedMechanical;
    data['FullyApprovedMechanical'] = this.fullyApprovedMechanical;
    data['PendingErection'] = this.pendingErection;
    data['PartiallyErection'] = this.partiallyErection;
    data['FullyErection'] = this.fullyErection;
    data['RejectedErection'] = this.rejectedErection;
    data['FullyApprovedErection'] = this.fullyApprovedErection;
    data['PendingDryComm'] = this.pendingDryComm;
    data['FullyDryComm'] = this.fullyDryComm;
    data['PartiallyDryComm'] = this.partiallyDryComm;
    data['FullyApprovedDryComm'] = this.fullyApprovedDryComm;
    data['RejectedDryComm'] = this.rejectedDryComm;
    data['PendingWetComm'] = this.pendingWetComm;
    data['PartiallyWetComm'] = this.partiallyWetComm;
    data['FullyWetComm'] = this.fullyWetComm;
    data['FullyApprovedWetComm'] = this.fullyApprovedWetComm;
    data['RejectedWetComm'] = this.rejectedWetComm;
    data['PendingAutoDryComm'] = this.pendingAutoDryComm;
    data['FullyAutoDryComm'] = this.fullyAutoDryComm;
    data['PartiallyAutoDryComm'] = this.partiallyAutoDryComm;
    data['FullyApprovedAutoDryComm'] = this.fullyApprovedAutoDryComm;
    data['RejectedAutoDryComm'] = this.rejectedAutoDryComm;
    data['PendingAutoWetComm'] = this.pendingAutoWetComm;
    data['FullyAutoWetComm'] = this.fullyAutoWetComm;
    data['PartiallyAutoWetComm'] = this.partiallyAutoWetComm;
    data['FullyApprovedAutoWetComm'] = this.fullyApprovedAutoWetComm;
    data['RejectedAutoWetComm'] = this.rejectedAutoWetComm;
    data['PendingTrenching'] = this.pendingTrenching;
    data['PartiallyTrenching'] = this.partiallyTrenching;
    data['FullyTrenching'] = this.fullyTrenching;
    data['RejectedTrenching'] = this.rejectedTrenching;
    data['FullyApprovedTrenching'] = this.fullyApprovedTrenching;
    data['PendingPipeInstallation'] = this.pendingPipeInstallation;
    data['PartiallyPipeInstallation'] = this.partiallyPipeInstallation;
    data['FullyPipeInstallation'] = this.fullyPipeInstallation;
    data['RejectedPipeInstallation'] = this.rejectedPipeInstallation;
    data['FullyApprovedPipeInstallation'] = this.fullyApprovedPipeInstallation;
    data['PendingProcess1'] = this.pendingProcess1;
    data['PartiallyProcess1'] = this.partiallyProcess1;
    data['FullyProcess1'] = this.fullyProcess1;
    data['RejectedProcess1'] = this.rejectedProcess1;
    data['FullyApprovedProcess1'] = this.fullyApprovedProcess1;
    data['PendingProcess2'] = this.pendingProcess2;
    data['PartiallyProcess2'] = this.partiallyProcess2;
    data['FullyProcess2'] = this.fullyProcess2;
    data['RejectedProcess2'] = this.rejectedProcess2;
    data['FullyApprovedProcess2'] = this.fullyApprovedProcess2;
    data['PendingProcess3'] = this.pendingProcess3;
    data['FullyProcess3'] = this.fullyProcess3;
    data['PartiallyProcess3'] = this.partiallyProcess3;
    data['FullyApprovedProcess3'] = this.fullyApprovedProcess3;
    data['RejectedProcess3'] = this.rejectedProcess3;
    data['PendingProcess4'] = this.pendingProcess4;
    data['PartiallyProcess4'] = this.partiallyProcess4;
    data['FullyProcess4'] = this.fullyProcess4;
    data['FullyApprovedProcess4'] = this.fullyApprovedProcess4;
    data['RejectedProcess4'] = this.rejectedProcess4;
    data['PendingProcess5'] = this.pendingProcess5;
    data['PartiallyProcess5'] = this.partiallyProcess5;
    data['FullyProcess5'] = this.fullyProcess5;
    data['FullyApprovedProcess5'] = this.fullyApprovedProcess5;
    data['RejectedProcess5'] = this.rejectedProcess5;
    data['PendingProcess6'] = this.pendingProcess6;
    data['PartiallyProcess6'] = this.partiallyProcess6;
    data['FullyProcess6'] = this.fullyProcess6;
    data['FullyApprovedProcess6'] = this.fullyApprovedProcess6;
    data['RejectedProcess6'] = this.rejectedProcess6;
    return data;
  }
}
