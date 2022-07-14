import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/model/category/category_model.dart';
import 'package:flutter/material.dart';
import '../../../widgets/customSizedBox.dart';
import '../../addscreen/widgets/custom_elevated_button.dart';
import '../../addscreen/widgets/custom_radio_button.dart';
import 'package:budfi/model/transaction/transaction_model.dart';

class AddCategoryBottomSheet extends StatelessWidget {
  CategoryModel? updateID;
  AddCategoryBottomSheet({Key? key, this.updateID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _type = ValueNotifier(categorytype.income);
    final _categoryNameController = TextEditingController();
    if (updateID != null) {
      _categoryNameController.text = updateID!.categoryname;
      _type.value = updateID!.type;
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.longestSide / 1.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Theme.of(context).hintColor,
                thickness: 2,
                indent: MediaQuery.of(context).size.longestSide / 5,
                endIndent: MediaQuery.of(context).size.longestSide / 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextFormField(
                controller: _categoryNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: ValueListenableBuilder(
                  valueListenable: _type,
                  builder: (BuildContext context, categorytype changedValue,
                      Widget? _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        CustomSizedBox(width: 12),
                        CustomRadioButton(
                          value: categorytype.income,
                          groupValue: changedValue,
                          onChanged: (value) {
                            _type.value = value;
                            _type.notifyListeners();
                            print(_type.value);
                          },
                          text: 'Income',
                        ),
                        CustomRadioButton(
                          value: categorytype.expense,
                          groupValue: changedValue,
                          onChanged: (value) {
                            _type.value = value;
                            _type.notifyListeners();
                            print(_type.value);
                          },
                          text: 'Expense',
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
              child: CustomElevatedButtonWidget(
                buttonText: updateID == null ? 'Save' : 'Update',
                width: MediaQuery.of(context).size.width * 0.5,
                onpressed: () async {
                  if (updateID == null) {
                    if (_categoryNameController.text.isNotEmpty) {
                      await CategoryDB.instance.addCategoryes(
                        CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          categoryname: _categoryNameController.text,
                          type: _type.value,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                  if (updateID != null) {
                    if (_categoryNameController.text.isNotEmpty) {
                      CategoryDB.instance.updateCategory(
                        updateID!.id,
                        CategoryModel(
                            id: updateID!.id,
                            categoryname: _categoryNameController.text,
                            type: _type.value),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
