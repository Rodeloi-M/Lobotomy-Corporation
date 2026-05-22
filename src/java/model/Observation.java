package model;

public class Observation {
    private int    id;
    private int    abnormalityId;
    private int    levelNumber;
    private String bonus;
    private String unlockText;

    public int    getId()             { return id; }
    public int    getAbnormalityId()  { return abnormalityId; }
    public int    getLevelNumber()    { return levelNumber; }
    public String getBonus()          { return bonus; }
    public String getUnlockText()     { return unlockText; }

    public void setId(int id)                         { this.id = id; }
    public void setAbnormalityId(int abnormalityId)   { this.abnormalityId = abnormalityId; }
    public void setLevelNumber(int levelNumber)       { this.levelNumber = levelNumber; }
    public void setBonus(String bonus)                { this.bonus = bonus; }
    public void setUnlockText(String unlockText)      { this.unlockText = unlockText; }
}
