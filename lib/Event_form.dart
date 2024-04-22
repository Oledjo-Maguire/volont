class Event_form {
  String _eventName;
  String _catygory;
  String _startDate;
  String _endDate;
  String _location;

  Event_form(
      this._eventName, this._catygory, this._startDate, this._endDate, this._location
      );
  String toParams() => "?eventName=${_eventName.toString()}&category=${_catygory.toString()}&startDate=${_startDate.toString()}&endDate=${_endDate.toString()}&location=${_location.toString()}";
}