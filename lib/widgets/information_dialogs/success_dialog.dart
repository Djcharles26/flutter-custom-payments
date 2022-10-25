import 'package:flutter/material.dart';

Future showSuccessDialog(BuildContext context, {required String title,required String body, String okay = "Okay"}) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline2!.copyWith(
              color: Theme.of(context).primaryColorLight
            )),
            const SizedBox(height: 16,),
            Text(
              body, 
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  child: Text(okay, 
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Theme.of(context).primaryColorDark
                    ) 
                  ),
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    )
  );
}