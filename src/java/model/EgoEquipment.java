package model;

public class EgoEquipment {
    private int    id;
    private int    abnormalityId;
    private String weaponName;
    private String grade;
    private int    cost;
    private int    maxAmount;
    private String damage;
    private String attackSpeed;
    private String rangeType;
    private int    observationLevel;
    private String requirements;
    private String specialInfo;

    public int    getId()               { return id; }
    public int    getAbnormalityId()    { return abnormalityId; }
    public String getWeaponName()       { return weaponName; }
    public String getGrade()            { return grade; }
    public int    getCost()             { return cost; }
    public int    getMaxAmount()        { return maxAmount; }
    public String getDamage()           { return damage; }
    public String getAttackSpeed()      { return attackSpeed; }
    public String getRangeType()        { return rangeType; }
    public int    getObservationLevel() { return observationLevel; }
    public String getRequirements()     { return requirements; }
    public String getSpecialInfo()      { return specialInfo; }

    public void setId(int id)                           { this.id = id; }
    public void setAbnormalityId(int abnormalityId)     { this.abnormalityId = abnormalityId; }
    public void setWeaponName(String weaponName)        { this.weaponName = weaponName; }
    public void setGrade(String grade)                  { this.grade = grade; }
    public void setCost(int cost)                       { this.cost = cost; }
    public void setMaxAmount(int maxAmount)             { this.maxAmount = maxAmount; }
    public void setDamage(String damage)                { this.damage = damage; }
    public void setAttackSpeed(String attackSpeed)      { this.attackSpeed = attackSpeed; }
    public void setRangeType(String rangeType)          { this.rangeType = rangeType; }
    public void setObservationLevel(int observationLevel){ this.observationLevel = observationLevel; }
    public void setRequirements(String requirements)    { this.requirements = requirements; }
    public void setSpecialInfo(String specialInfo)      { this.specialInfo = specialInfo; }
}
