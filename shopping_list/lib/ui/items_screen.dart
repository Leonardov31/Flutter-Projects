import 'package:flutter/material.dart';
import 'package:shopping_list/ui/list_item_dialog.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../utils/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen({Key key, this.shoppingList}) : super(key: key);
  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  DbHelper helper;
  List<ListItem> items;
  final ShoppingList shoppingList;
  ListItemDialog dialog = new ListItemDialog();

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }

  _ItemsScreenState(this.shoppingList);
  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text(
              'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
            ),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      dialog.buildAlert(context, items[index], false),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
              context,
              ListItem(0, shoppingList.id, '', '', ''),
              true,
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
