package model;

public class WorkProbability {
    private int    id;
    private int    abnormalityId;
    private String workType;
    private String level1;
    private String level2;
    private String level3;
    private String level4;
    private String level5;

    public int    getId()            { return id; }
    public int    getAbnormalityId() { return abnormalityId; }
    public String getWorkType()      { return workType; }
    public String getLevel1()        { return level1; }
    public String getLevel2()        { return level2; }
    public String getLevel3()        { return level3; }
    public String getLevel4()        { return level4; }
    public String getLevel5()        { return level5; }

    public void setId(int id)                       { this.id = id; }
    public void setAbnormalityId(int v)             { this.abnormalityId = v; }
    public void setWorkType(String workType)        { this.workType = workType; }
    public void setLevel1(String level1)            { this.level1 = level1; }
    public void setLevel2(String level2)            { this.level2 = level2; }
    public void setLevel3(String level3)            { this.level3 = level3; }
    public void setLevel4(String level4)            { this.level4 = level4; }
    public void setLevel5(String level5)            { this.level5 = level5; }
}
