class Question{
  final String _questionText;
  final bool _isCorrect;
  final String _image;

  Question.name(this._questionText, this._isCorrect, this._image);

  bool get isCorrect => _isCorrect;

  String get questionText => _questionText;

  String get image => _image;
}
