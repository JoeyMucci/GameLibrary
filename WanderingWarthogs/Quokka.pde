public class Quokka extends Mascot {
    public Quokka(float x, float y, boolean facingRight) {
        super(x, y, facingRight);
        this.species = "quokka";
        this.leftKey = 'a';
        this.rightKey = 'd';
        this.jumpKey = 'w';
        this.actionKey = 's';
        super.setSprite();
    }
}