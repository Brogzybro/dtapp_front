class ECG {
  ECG(this.signalid, this.signal, this.sampling_frequency, this.wearposition);
  int signalid;
  List<int> signal;
  int sampling_frequency;
  int wearposition;

  ECG.fromJson(Map<String, dynamic> json) {
    try {
      signalid = json['signalid'];
      signal = (json['signal'] as List).map((vol) => vol as int).toList();
      sampling_frequency = json['sampling_frequency'];
      wearposition = json['wearposition'];
    } catch (e) {
      print('Invalid ECG sample');
      print(e);
    }
  }
}
