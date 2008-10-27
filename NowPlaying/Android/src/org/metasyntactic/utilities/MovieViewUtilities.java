package org.metasyntactic.utilities;

import android.content.res.Resources;
import android.graphics.drawable.Drawable;

import org.metasyntactic.R;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;

import java.util.Comparator;

public class MovieViewUtilities {

    /**
     * Formats the movie rating for display. For example if a movie is rated PG
     * 13, the ratings string is "Rated PG-13.". If a movie is unrated then the
     * ratings string is "Unrated."
     * 
     * @param rating Movie rating.
     * @param res Context resources handle.
     */
    public static CharSequence formatRatings(String rating, Resources res) {
        CharSequence ratingStr =
            (rating.equals("")) ? res.getText(R.string.unrated) : (res
                .getText(R.string.rated)
                + rating + res.getText(R.string.ratingslengthstr_separator));
        return ratingStr;
    }

    /**
     * Formats the movie length for display. The movie length is displayed as
     * "x hours y minutes".
     * 
     * @param length Movie length in minutes.
     * @param res Context resources handle.
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
    
    

}
