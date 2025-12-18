import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:greycell_app/src/commons/widgets/not_found.dart';
import 'package:greycell_app/src/manager/main_model.dart';
import 'package:greycell_app/src/models/school/school_contact.dart';
import 'package:greycell_app/src/views/observer/future_observer.dart';

class MyAboutSchool extends StatefulWidget {
  final MainModel model;

  MyAboutSchool({required this.model});

  @override
  _MyAboutSchoolState createState() => _MyAboutSchoolState();
}

class _MyAboutSchoolState extends State<MyAboutSchool> {
  Future<SchoolContact?>? _result;
  final double minValue = 8.0;

  void _onCreate() async {
    _result = widget.model.getContactDetails();
  }

  @override
  void initState() {
    super.initState();
    _onCreate();
  }

  Widget _buildError() {
    return Container(
      child: Center(child: Text("Internal Error Occured")),
    );
  }

  Widget _lofo() {
    return Container(
      height: 70,
      width: 70.0,
      padding: EdgeInsets.all(minValue * 2),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(minValue * 2)),
//          gradient: LinearGradient(
//              colors: [Colors.deepPurple[900], Colors.deepPurpleAccent])
      ),
      alignment: Alignment.center,
      child: widget.model.school?.schoolLogo == null
          ? Icon(Icons.school, size: 40, color: Colors.grey[600])
          : ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(minValue * 2)),
              child: CachedNetworkImage(
                imageUrl: widget.model.school!.schoolLogo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(SchoolContact schoolContact) {
    return Container(
      height: 140.0,
      padding: EdgeInsets.symmetric(horizontal: minValue),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _lofo(),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "${schoolContact.getBranchName!.toUpperCase()}",
//              textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: Colors.black87, fontWeightDelta: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SchoolContact schoolContact) {
    final iconColor = Colors.white;
    final leadColor = Theme.of(context).primaryColor;

    final address = schoolContact.getBranchAddress ??
        "${schoolContact.getAddressLine1}, ${schoolContact.getAddressLine2}, ${schoolContact.getAddressLine3}";

    return Container(
      child: ListView(
        children: <Widget>[
          _buildHeader(schoolContact),
          Card(
            elevation: 0.2,
            margin: EdgeInsets.all(minValue),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(minValue * 2))),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Contact",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.call,
                      color: iconColor,
                    ),
                  ),
                  title: Text("${schoolContact.getMobileNo ?? ' '}"),
                  subtitle: Text("Mobile No"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.phone_android,
                      color: iconColor,
                    ),
                  ),
                  title: Text(
                      "${schoolContact.getPhone1 ?? ' '}, ${schoolContact.getPhone2 ?? ' '}"),
                  subtitle: Text("Alternate"),
                ),
//                ListTile(
//                  leading: CircleAvatar(
//                    backgroundColor: leadColor,
//                    child: Icon(
//                      Icons.phone_android,
//                      color: iconColor,
//                    ),
//                  ),
//                  title: Text("${schoolContact.getPhone2}"),
//                  subtitle: Text("Phone No 2"),
//                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.my_location,
                      color: iconColor,
                    ),
                  ),
                  title: Text(address),
                  subtitle: Text("Address"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.location_city,
                      color: iconColor,
                    ),
                  ),
                  title: Text("${schoolContact.getCityName ?? ' '}"),
                  subtitle: Text("City"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.stars,
                      color: iconColor,
                    ),
                  ),
                  title: Text("${schoolContact.getStateName ?? ' '}"),
                  subtitle: Text("State"),
                ),

                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: leadColor,
                    child: Icon(
                      Icons.fiber_pin,
                      color: iconColor,
                    ),
                  ),
                  title: Text("${schoolContact.getPin ?? ' '}"),
                  subtitle: Text("Pincode"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About "),
      ),
      body: FutureObserver(
        future: _result,
        onSuccess: (context, SchoolContact schoolContact) {
          if (schoolContact == null)
            return MyNotFound(
              title: "No Data Available",
              onRetry: _onCreate,
            );
          else {
            return _buildBody(schoolContact);
          }
        },
      ),
    );
  }
}
