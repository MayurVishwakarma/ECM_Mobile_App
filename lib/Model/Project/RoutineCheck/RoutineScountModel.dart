class RoutineScountModel {
  int? sCount;
  int? pending;
  int? partiallyDone;
  int? fullyDone;
  int? last30DaysFullyDone;
  int? last15DaysFullyDone;
  int? last7DaysFullyDone;
  int? last30DaysPartiallyDone;
  int? last15DaysPartiallyDone;
  int? last7DaysPartiallyDone;

  RoutineScountModel(
      {this.sCount,
      this.pending,
      this.partiallyDone,
      this.fullyDone,
      this.last30DaysFullyDone,
      this.last15DaysFullyDone,
      this.last7DaysFullyDone,
      this.last30DaysPartiallyDone,
      this.last15DaysPartiallyDone,
      this.last7DaysPartiallyDone});

  RoutineScountModel.fromJson(Map<String, dynamic> json) {
    sCount = json['SCount'];
    pending = json['Pending'];
    partiallyDone = json['PartiallyDone'];
    fullyDone = json['FullyDone'];
    last30DaysFullyDone = json['Last30DaysFullyDone'];
    last15DaysFullyDone = json['Last15DaysFullyDone'];
    last7DaysFullyDone = json['Last7DaysFullyDone'];
    last30DaysPartiallyDone = json['Last30DaysPartiallyDone'];
    last15DaysPartiallyDone = json['Last15DaysPartiallyDone'];
    last7DaysPartiallyDone = json['Last7DaysPartiallyDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SCount'] = this.sCount;
    data['Pending'] = this.pending;
    data['PartiallyDone'] = this.partiallyDone;
    data['FullyDone'] = this.fullyDone;
    data['Last30DaysFullyDone'] = this.last30DaysFullyDone;
    data['Last15DaysFullyDone'] = this.last15DaysFullyDone;
    data['Last7DaysFullyDone'] = this.last7DaysFullyDone;
    data['Last30DaysPartiallyDone'] = this.last30DaysPartiallyDone;
    data['Last15DaysPartiallyDone'] = this.last15DaysPartiallyDone;
    data['Last7DaysPartiallyDone'] = this.last7DaysPartiallyDone;
    return data;
  }
}
