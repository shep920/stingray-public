import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/admin%20bloc/admin_bloc.dart';
import 'package:hero/widgets/admin_number_pad.dart';

class AdminTile extends StatelessWidget {
  const AdminTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.admin_panel_settings),
      title: Text('Admin panel',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.green)),
      onTap: () async {
        bool? result = await Show.showNumberKeypad(context);

        if (result == true) {
          BlocProvider.of<AdminBloc>(context).add(LoadAdmin());
          Navigator.pushNamed(context, '/admin');
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
