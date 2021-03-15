import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key key,
    @required this.contactIndex,
  }) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    // If you don't need to rebuild the widget tree once the model's data changes
    // (when you only make changes to the model, like in this ContactCard),
    // you don't need to use ScopedModelDescendant with a builder, but only simply
    // call ScopedModel.of<T>() function
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      // Thee actions show while swiping to the left
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            model.deleteContact(displayedContact);
          },
        )
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Call',
          color: Colors.green,
          icon: Icons.phone,
          onTap: () => _callPhoneNumber(
            context,
            displayedContact.phoneNumber,
          ),
        ),
        IconSlideAction(
          caption: 'Email',
          color: Colors.blue,
          icon: Icons.mail,
          onTap: () => _writeEmail(
            context,
            displayedContact.email,
          ),
        ),
      ],
      child: _buildContent(
        context,
        displayedContact,
        model,
      ),
    );
  }

  Future _callPhoneNumber(
    BuildContext context,
    String number,
  ) async {
    final url = 'tel:$number';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot make a call'),
      );
      // Showing an error message
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(
    BuildContext context,
    String emailAddress,
  ) async {
    final url = 'mailto:$emailAddress';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot make an email'),
      );
      // Showing an error message
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    ContactsModel model,
  ) {
    // Containers are used to style your UI
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        leading: _buildCircleAvatar(displayedContact),
        trailing: IconButton(
          icon: Icon(
            displayedContact.isFavorite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            model.changeFavoriteStatus(displayedContact);
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ContactEditPage(
              editedContact: displayedContact,
            ),
          ));
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    // Hero widget facilitates a hero animation between routes (pages) in a simple way.
    // It's important that the tag is the SAME and UNIQUE in both routes
    return Hero(
      // HashCode returns a fairly unique integer based on
      // the content of the displayedContact object.
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    // Display the first letter from contact's name
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.name[0],
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.imageFile,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
