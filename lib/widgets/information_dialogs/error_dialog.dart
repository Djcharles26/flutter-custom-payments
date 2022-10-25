import 'package:flutter/material.dart';
import 'package:http_request_utils/body_utils.dart';

Future<dynamic> showErrorDialog(
  BuildContext context, {
    HttpException? exception,
    String? title, 
    String? message,
    String? submessage
  } 
){
  if(exception != null) {
    title = "An error occured";
    title += " ";
    message = exception.message;
    submessage = exception.submessage;
    switch(exception.code){
      case Code.request:
        title += "in server";
        switch(exception.status) {
          case 400:
            message = " 400";
          break;
          case 401:
            message = " 401";
          break;
          case 404:
            message = " 404";
          break;
          case 500:
            message = " 500";
          break;
          case 502:
            message = " 502";
          break;
          case 504:
            message = " 504";
          break;
        }
      break;
      case Code.system:
        title += "in device";
      break;
      case Code.unauthorized:
        title += "authorizing";
      break;
      default:
        title += "";
      break;
    }

  }

  return showDialog(
    context: context, 
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Theme.of(context).backgroundColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title!, textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.headline2?.copyWith(color: Theme.of(context).secondaryHeaderColor)
                ),
                const SizedBox(height: 16,),
                Text(message!, textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText1
                ),
                const SizedBox(height: 16,),
                Center(
                  child: Visibility (
                    visible: exception?.submessage != null,
                    child: Text (
                      (exception?.submessage ?? ""),
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay", style: Theme.of(context).textTheme.overline),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    )
  );
}