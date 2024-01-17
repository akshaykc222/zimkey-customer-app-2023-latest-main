import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@immutable
class NormalDialogTemplate {
  static double sizeSmallxxx = 4;

  static Widget makeTemplate(
    Widget child, {
    required PositionDialog positionDialog,
    required Color backgroundColor,
    EdgeInsets? insetPadding,
    required Function onDismiss,
    EdgeInsets? insetMargin,
    bool useDragDismiss = false,
    required Key key,
  }) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: _getPositionDialog(positionDialog),
            child: useDragDismiss
                ? Dismissible(
                    key: key,
                    dragStartBehavior: DragStartBehavior.down,
                    direction: DismissDirection.up,
                    onDismissed: (direction) {
                      onDismiss();
                    },
                    child: Container(
                      margin: insetMargin,
                      padding: insetPadding ?? const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.rectangle,
                        borderRadius: _getBorderRadius(positionDialog),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(0.0, 2),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  )
                : Container(
                    margin: insetMargin,
                    padding: insetPadding ?? const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.rectangle,
                      borderRadius: _getBorderRadius(positionDialog),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(0.0, 3),
                        ),
                      ],
                    ),
                    child: child,
                  ),
          ),
        ),
      ],
    );
  }

  static BorderRadius _getBorderRadius(PositionDialog positionDialog) {
    switch (positionDialog) {
      case PositionDialog.topCenter:
        return BorderRadius.only(
            bottomLeft: Radius.circular(sizeSmallxxx),
            bottomRight: Radius.circular(sizeSmallxxx));
      case PositionDialog.center:
        return BorderRadius.circular(sizeSmallxxx);
      case PositionDialog.bottomCenter:
        return BorderRadius.only(
            topLeft: Radius.circular(sizeSmallxxx),
            topRight: Radius.circular(sizeSmallxxx));
      default:
        return BorderRadius.circular(sizeSmallxxx);
    }
  }

  static Alignment _getPositionDialog(PositionDialog positionDialog) {
    switch (positionDialog) {
      case PositionDialog.topCenter:
        return Alignment.topCenter;
      case PositionDialog.center:
        return Alignment.center;
      case PositionDialog.bottomCenter:
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }
}

enum PositionDialog { topCenter, center, bottomCenter }
