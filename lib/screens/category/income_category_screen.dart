import 'package:budfi/db/category/category_db.dart';
import 'package:flutter/material.dart';
import '../../model/category/category_model.dart';
import '../../theme/Light/colors/colors.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'widgets/add_category_bottom_sheet.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB.instance.incomeCategoryListNotifier,
        builder: (BuildContext context, List<CategoryModel> newListCategory,
            Widget? _) {
          return ListView.builder(
            itemCount: newListCategory.length,
            itemBuilder: (BuildContext context, int index) {
              CategoryModel db = newListCategory[index];
              return Card(
                elevation: 0.20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  title: Text(
                    db.categoryname,
                    style: const TextStyle(
                      fontFamily: 'Prompt',
                      color: BudFiColor.textColorBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  trailing: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text('Delete'),
                        )
                      ];
                    },
                    onSelected: (value) async {
                      if (value == 1) {
                        if (db.id.isNotEmpty) {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return AddCategoryBottomSheet(
                                updateID: db,
                              );
                            },
                          );
                        }
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              heading: 'Delete message',
                              content:
                                  'Are you sure ? Do you want to delete this Category?',
                              firstbuttonName: 'DELETE',
                              secondbuttonName: 'CANCLE',
                              onpressedFirstbutton: () {
                                if (db.id.isNotEmpty) {
                                  CategoryDB.instance.deleteCategoryes(db.id);
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        });
  }
}
