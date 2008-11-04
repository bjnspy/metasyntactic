package org.metasyntactic.utilities;

import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.location.Address;
import android.location.Geocoder;
import android.widget.Toast;

import org.metasyntactic.R;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.io.IOException;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;

public class MovieViewUtilities {
    
    // Constants for movies sort
    private final static int MovieTitle = 0;
    private final static int Release = 1;
    private final static int Score = 2;
    
    // constants for Theaters sort
    private final static int TheaterName = 0;
    private final static int Distance = 1;
    
    
    private static String currentHeader;
    
  /**
   * Formats the movie rating for display. For example if a movie is rated PG 13, the ratings string is "Rated PG-13.".
   * If a movie is unrated then the ratings string is "Unrated."
   *
   * @param rating Movie rating.
   * @param res    Context resources handle.
   */ 
    
  public static CharSequence formatRatings(String rating, Resources res) {
    CharSequence ratingStr =
        (rating.equals("")) ? res.getText(R.string.unrated) : (res
            .getText(R.string.rated)
            + rating + res.getText(R.string.ratingslengthstr_separator));
    return ratingStr;
  }


  /**
   * Formats the movie length for display. The movie length is displayed as "x hours y minutes".
   *
   * @param length Movie length in minutes.
   * @param res    Context resources handle.
   */
  public static CharSequence formatLength(int length, Resources res) {
    String hoursString = "";
    String minutesString = "";

    if (length > 0) {
      int hours = length / 60;
      int minutes = length % 60;

      if (hours == 1) {
        hoursString =
            String.format(res.getString(R.string.onehour), null);
      } else if (hours > 1) {
        hoursString =
            String.format("%d " + res.getString(R.string.hours), hours);
      }

      if (minutes == 1) {
        minutesString =
            String.format(res.getString(R.string.oneminute), null);
      } else if (minutes > 1) {
        minutesString =
            String.format("%d " + res.getString(R.string.minutes),
                minutes);
      }
    }

    return String.format("%s %s", hoursString, minutesString);
  }


  public static Drawable formatScoreDrawable(int score, ScoreType scoreType,
                                             Resources res) {

    if (scoreType == ScoreType.RottenTomatoes) {
      return formatRottenTomatoesDrawable(score, res);
    }
    return formatBasicSquareDrawable(score, res);
  }


  private static Drawable formatRottenTomatoesDrawable(int score,
                                                       Resources res) {
    Drawable scoreDrawable = null;
    scoreDrawable = res.getDrawable(R.drawable.rating_unknown);
    if (score >= 0 && score <= 100) {
      if (score >= 60) {
        scoreDrawable = res.getDrawable(R.drawable.fresh);
      } else {
        scoreDrawable = res.getDrawable(R.drawable.rotten_faded);
      }
    }

    return scoreDrawable;
  }


  private static Drawable formatBasicSquareDrawable(int score, Resources res) {
    Drawable scoreDrawable = null;
    scoreDrawable = res.getDrawable(R.drawable.rating_unknown);
    if (score >= 0 && score <= 40) {
      scoreDrawable = res.getDrawable(R.drawable.rating_red);
    } else if (score > 40 && score <= 60) {
      scoreDrawable = res.getDrawable(R.drawable.rating_yellow);
    } else if (score > 60 && score <= 100) {
      scoreDrawable = res.getDrawable(R.drawable.rating_green);
    }
    return scoreDrawable;
  }


public static String getHeader(List<Movie> movies, int position, int sortIndex) {
    // TODO Auto-generated method stub
    switch(sortIndex) {
        case MovieTitle: 
            if (position == 0)
                return String.valueOf(movies.get(position).getDisplayTitle().charAt(0));
            if (movies.get(position).getDisplayTitle().charAt(0) != movies.get(position - 1).getDisplayTitle().charAt(0)) 
                return String.valueOf(movies.get(position).getDisplayTitle().charAt(0));
            break;
        case Release:
            Date d1 = movies.get(position).getReleaseDate();
            DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
            String dateStr;
            if(d1 != null) 
                dateStr = df.getDateInstance().format(d1);
             else
                dateStr = null;
    
            
            if ( position == 0 ) {
                
                return dateStr;
            }
            Date d2 = movies.get(position - 1).getReleaseDate();
            if ((d2 != null) &&  (d1 != null) && !(d1.equals(d2))) {         
               
                return dateStr;
            }
            return null;
            
    }
    return null;
}


public static String getTheaterHeader(List<Theater> theaters, int position,
                int sortIndex, Address address) {
    
    // TODO Auto-generated method stub
    switch(sortIndex) {
        case TheaterName: 
            if (position == 0)
                return String.valueOf(theaters.get(position).getName().charAt(0));
            if (theaters.get(position).getName().charAt(0) != theaters.get(position - 1).getName().charAt(0)) 
                return String.valueOf(theaters.get(position).getName().charAt(0));
            break;
        case Distance:
           
           //todo (mjoshi) fix this ...incorrect headers are returned, and its slow.
            
            Location userLocation =
                new Location(address.getLatitude(), address.getLongitude(),
                    null, null, null, null, null);
            
           double dist_m1 = userLocation.distanceTo(theaters.get(position).getLocation());
           // Double dist_m2 = userLocation.distanceTo(m2.getLocation());
          
           if (dist_m1 <= 2 && dist_m1 >= 0 && currentHeader!= "Less than 2 miles") {
               currentHeader = "Less than 2 miles";
               return currentHeader;
           }
           if (dist_m1 <= 5 && dist_m1 >= 2 && currentHeader!= "Less than 5 miles") {
               currentHeader = "Less than 5 miles";
               return currentHeader;
           }
           if (dist_m1 <= 10 && dist_m1 >= 5 && currentHeader!= "Less than 10 miles") {
               currentHeader = "Less than 10 miles";
               return currentHeader;
           }
           if (dist_m1 <= 25 && dist_m1 >= 10 && currentHeader!= "Less than 25 miles") {
               currentHeader = "Less than 25 miles";
               return currentHeader;
           }
           if (dist_m1 <= 50 && dist_m1 >= 25 && currentHeader!= "Less than 50 miles") {
               currentHeader = "Less than 50 miles";
               return currentHeader;
           }
           if (dist_m1 <= 100 && dist_m1 >= 50 && currentHeader!= "Less than 100 miles") {
               currentHeader = "Less than 100 miles";
               return currentHeader;
           } 
           if (position ==0 ){
               return currentHeader;
           }
            
    }
    return null;
}


}
