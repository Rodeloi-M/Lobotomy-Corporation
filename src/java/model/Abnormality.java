package model;

/**
 * Modelo de dados para a entidade Abnormality (Anormalidade).
 * Mapeado à tabela `abnormality` da base de dados lobotomy_corp.
 */
public class Abnormality {

    private int    id;
    private String nome;
    private String codigo;
    private int    eboxes;
    private String attackType;
    private String attackDamage;
    private String riskLevel;
    private boolean facilityBenefit;
    private String goodMood;
    private String normalMood;
    private String badMood;
    private String qliphothCounter;
    private String descricao;
    private String ability;
    private String originText;
    private String detailsText;
    private String story;
    private String flavourText;
    private String trivia;
    private String imagem;

    public Abnormality() {}

    // ─── Getters ────────────────────────────────────────────

    public int    getId()             { return id; }
    public String getNome()           { return nome; }
    public String getCodigo()         { return codigo; }
    public int    getEboxes()         { return eboxes; }
    public String getAttackType()     { return attackType; }
    public String getAttackDamage()   { return attackDamage; }
    public String getRiskLevel()      { return riskLevel; }
    public boolean isFacilityBenefit(){ return facilityBenefit; }
    public String getGoodMood()       { return goodMood; }
    public String getNormalMood()     { return normalMood; }
    public String getBadMood()        { return badMood; }
    public String getQliphothCounter(){ return qliphothCounter; }
    public String getDescricao()      { return descricao; }
    public String getAbility()        { return ability; }
    public String getOriginText()     { return originText; }
    public String getDetailsText()    { return detailsText; }
    public String getStory()          { return story; }
    public String getFlavourText()    { return flavourText; }
    public String getTrivia()         { return trivia; }
    public String getImagem()         { return imagem; }

    // ─── Setters ────────────────────────────────────────────

    public void setId(int id)                         { this.id = id; }
    public void setNome(String nome)                  { this.nome = nome; }
    public void setCodigo(String codigo)              { this.codigo = codigo; }
    public void setEboxes(int eboxes)                 { this.eboxes = eboxes; }
    public void setAttackType(String attackType)      { this.attackType = attackType; }
    public void setAttackDamage(String attackDamage)  { this.attackDamage = attackDamage; }
    public void setRiskLevel(String riskLevel)        { this.riskLevel = riskLevel; }
    public void setFacilityBenefit(boolean b)         { this.facilityBenefit = b; }
    public void setGoodMood(String goodMood)          { this.goodMood = goodMood; }
    public void setNormalMood(String normalMood)      { this.normalMood = normalMood; }
    public void setBadMood(String badMood)            { this.badMood = badMood; }
    public void setQliphothCounter(String q)          { this.qliphothCounter = q; }
    public void setDescricao(String descricao)        { this.descricao = descricao; }
    public void setAbility(String ability)            { this.ability = ability; }
    public void setOriginText(String originText)      { this.originText = originText; }
    public void setDetailsText(String detailsText)    { this.detailsText = detailsText; }
    public void setStory(String story)                { this.story = story; }
    public void setFlavourText(String flavourText)    { this.flavourText = flavourText; }
    public void setTrivia(String trivia)              { this.trivia = trivia; }
    public void setImagem(String imagem)              { this.imagem = imagem; }

    @Override
    public String toString() {
        return "Abnormality{id=" + id + ", nome='" + nome + "', codigo='" + codigo + "', riskLevel='" + riskLevel + "'}";
    }
}
