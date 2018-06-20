import 'package:firebase_auth/firebase_auth.dart';

import 'user.dart';

class Favorites {
  static void setCandidateFavorite(
      Map favs, FirebaseUser firebaseUser, Map candidate) {
    if (candidate.containsKey('oldFavId')) {
      favs.remove(candidate['oldFavId']);
    }

    final favId = candidate['favId'];
    if (candidate['fav']) {
      favs.remove(favId);
    } else {
      favs[favId] = {'fav': true};
    }

    User.getFavCandidatesRef(firebaseUser).setData(favs);
  }

  static bool isFav(Map favs, String favId) {
    if (favId == null) {
      return false;
    }
    Map favData = favs[favId];
    return favData == null ? false : favData['fav'] ?? false;
  }
}
