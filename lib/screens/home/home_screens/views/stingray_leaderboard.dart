import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:hero/models/stingrays/stingray_stats_model.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Stingray?> stingrays;
  final List<StingrayStats?> stats;

  LeaderboardWidget({
    required this.stingrays,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final sortedStats = stats.toList()
      ..sort((a, b) => b!.totalScore.compareTo(a!.totalScore));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if(sortedStats.length > 0)
        _buildLeaderboardItem(
          stingray:
              stingrays.firstWhere((s) => s!.id == sortedStats[0]!.stingrayId)!,
          totalScore: sortedStats[0]!.totalScore,
          position: 1,
          isTopItem: true,
        ),
        if(sortedStats.length > 1)
        _buildLeaderboardItem(
          stingray:
              stingrays.firstWhere((s) => s!.id == sortedStats[1]!.stingrayId)!,
          totalScore: sortedStats[1]!.totalScore,
          position: 2,
        ),
        if(sortedStats.length > 2)
        _buildLeaderboardItem(
          stingray:
              stingrays.firstWhere((s) => s!.id == sortedStats[2]!.stingrayId)!,
          totalScore: sortedStats[2]!.totalScore,
          position: 3,
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required Stingray stingray,
    required int totalScore,
    required int position,
    bool isTopItem = false,
  }) {
    final TextStyle positionTextStyle = TextStyle(
      fontSize: 24.0,
      fontWeight: isTopItem ? FontWeight.bold : FontWeight.normal,
    );
    final double imageSize = isTopItem ? 100.0 : 60.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        children: [
          if (isTopItem)
            Icon(
              Icons.star,
              color: Colors.yellow[700],
              size: 32.0,
            ),
          SizedBox(width: 16.0),
          Text(
            '$position',
            style: positionTextStyle,
          ),
          SizedBox(width: 16.0),
          CachedNetworkImage(
            imageUrl: stingray.imageUrls[0],
            height: imageSize,
            width: imageSize,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stingray.name}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Total Score: $totalScore',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
