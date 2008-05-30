import java.util.*;

// generate a random height, given a max level and a probability
public class RandomHeight {
    private Random rand;
    private int    maxLevel;
    private double probability;
    
    public RandomHeight(int maxLvl, double prob) {
        maxLevel    = maxLvl;
        probability = prob;
        rand        = new Random();
    }
    
    public int newLevel() {
        int tmpLvl = 1;
        // Develop a random number between 1 and maxLvl (node height).
        while ((rand.nextFloat() < probability) && (tmpLvl < maxLevel)) {
            tmpLvl++;
        }

        return tmpLvl;
    }

};
