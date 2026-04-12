class ContractAnnex {
  ContractAnnex({
    this.title = '',
    List<AnnexSubtitle>? subtitles,
  }) : subtitles = subtitles ?? <AnnexSubtitle>[];

  String title;
  final List<AnnexSubtitle> subtitles;

  factory ContractAnnex.fromJson(dynamic json) {
    if (json is! Map) {
      return ContractAnnex();
    }

    final rawSubtitles = json['subtitles'];
    final subtitles = <AnnexSubtitle>[];
    if (rawSubtitles is List) {
      for (final rawSubtitle in rawSubtitles) {
        subtitles.add(AnnexSubtitle.fromJson(rawSubtitle));
      }
    }

    return ContractAnnex(
      title: json['title']?.toString() ?? '',
      subtitles: subtitles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitles': subtitles.map((subtitle) => subtitle.toJson()).toList(),
    };
  }

  void addSubtitle() {
    subtitles.add(AnnexSubtitle());
  }

  void removeSubtitle(AnnexSubtitle subtitle) {
    subtitles.remove(subtitle);
  }

  void moveSubtitleUp(AnnexSubtitle subtitle) {
    final index = subtitles.indexOf(subtitle);
    if (index <= 0) {
      return;
    }

    subtitles.removeAt(index);
    subtitles.insert(index - 1, subtitle);
  }

  void moveSubtitleDown(AnnexSubtitle subtitle) {
    final index = subtitles.indexOf(subtitle);
    if (index == -1 || index >= subtitles.length - 1) {
      return;
    }

    subtitles.removeAt(index);
    subtitles.insert(index + 1, subtitle);
  }

  List<AnnexSubtitle> get displayableSubtitles {
    return subtitles
        .where((subtitle) => subtitle.hasDisplayableContent)
        .toList(growable: false);
  }
}

class AnnexSubtitle {
  AnnexSubtitle({
    this.title = '',
    List<AnnexRemark>? remarks,
  }) : remarks = remarks ?? <AnnexRemark>[];

  String title;
  final List<AnnexRemark> remarks;

  factory AnnexSubtitle.fromJson(dynamic json) {
    if (json is! Map) {
      return AnnexSubtitle();
    }

    final rawRemarks = json['remarks'];
    final remarks = <AnnexRemark>[];
    if (rawRemarks is List) {
      for (final rawRemark in rawRemarks) {
        remarks.add(AnnexRemark.fromJson(rawRemark));
      }
    }

    return AnnexSubtitle(
      title: json['title']?.toString() ?? '',
      remarks: remarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'remarks': remarks.map((remark) => remark.toJson()).toList(),
    };
  }

  void addRemark() {
    remarks.add(AnnexRemark());
  }

  void removeRemark(AnnexRemark remark) {
    remarks.remove(remark);
  }

  void moveRemarkUp(AnnexRemark remark) {
    final index = remarks.indexOf(remark);
    if (index <= 0) {
      return;
    }

    remarks.removeAt(index);
    remarks.insert(index - 1, remark);
  }

  void moveRemarkDown(AnnexRemark remark) {
    final index = remarks.indexOf(remark);
    if (index == -1 || index >= remarks.length - 1) {
      return;
    }

    remarks.removeAt(index);
    remarks.insert(index + 1, remark);
  }

  List<AnnexRemark> get displayableRemarks {
    return remarks
        .where((remark) => remark.text.trim().isNotEmpty)
        .toList(growable: false);
  }

  bool get hasDisplayableContent {
    return title.trim().isNotEmpty || displayableRemarks.isNotEmpty;
  }
}

class AnnexRemark {
  AnnexRemark({
    this.text = '',
  });

  String text;

  factory AnnexRemark.fromJson(dynamic json) {
    if (json is Map) {
      return AnnexRemark(text: json['text']?.toString() ?? '');
    }

    return AnnexRemark(text: json?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
