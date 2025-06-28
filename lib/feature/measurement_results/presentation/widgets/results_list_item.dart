import 'package:flutter/material.dart';

class ResultsListItem extends StatefulWidget {
  final String title;
  final String? description;
  final bool isReferentMeasurement;
  final VoidCallback onTapSetReferent;
  final bool isFavoriteMeasurement;
  final VoidCallback onTapSetFavorite;
  final VoidCallback onTapDelete;
  final VoidCallback onTapOpenDetails;

  const ResultsListItem({
    super.key,
    required this.title,
    this.description,
    required this.isReferentMeasurement,
    required this.onTapSetReferent,
    required this.isFavoriteMeasurement,
    required this.onTapSetFavorite,
    required this.onTapDelete,
    required this.onTapOpenDetails,
  });

  @override
  State<ResultsListItem> createState() => _ResultsListItemState();
}

class _ResultsListItemState extends State<ResultsListItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: widget.onTapOpenDetails,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: widget.isReferentMeasurement ? Colors.greenAccent : Colors.grey[350],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(padding: const EdgeInsets.all(10),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.title,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(padding: const EdgeInsets.all(10),
                          child: Text(
                              widget.description ?? ""
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onTapSetReferent,
                        child: Padding(padding: const EdgeInsets.all(10),
                          child: Icon(
                            widget.isReferentMeasurement ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTapSetFavorite,
                        child: Padding(padding: const EdgeInsets.all(10),
                          child: Icon(
                            widget.isFavoriteMeasurement ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: widget.isFavoriteMeasurement ? Colors.redAccent : Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTapDelete,
                        child: Padding(padding: const EdgeInsets.all(10),
                          child: Icon(Icons.delete_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}