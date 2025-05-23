class MateriModel {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String kelas;
  final String type;
  final String fileName;
  final String fileSize;
  final String uploadDate;
  final int views;

  MateriModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.kelas,
    required this.type,
    required this.fileName,
    required this.fileSize,
    required this.uploadDate,
    required this.views,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      kelas: json['kelas']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      fileSize: json['fileSize']?.toString() ?? '',
      uploadDate: json['uploadDate']?.toString() ?? '',
      views: json['views'] ?? 0,
    );
  }

  // Method untuk mengkonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'kelas': kelas,
      'type': type,
      'fileName': fileName,
      'fileSize': fileSize,
      'uploadDate': uploadDate,
      'views': views,
    };
  }

  // Method untuk membuat copy dengan perubahan tertentu
  MateriModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    String? kelas,
    String? type,
    String? fileName,
    String? fileSize,
    String? uploadDate,
    int? views,
  }) {
    return MateriModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      kelas: kelas ?? this.kelas,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      uploadDate: uploadDate ?? this.uploadDate,
      views: views ?? this.views,
    );
  }

  @override
  String toString() {
    return 'MateriModel(id: $id, title: $title, subject: $subject, kelas: $kelas, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MateriModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}