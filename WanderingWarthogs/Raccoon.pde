public class Raccoon extends Mascot {
    public Raccoon(float x, float y, boolean facingRight) {
        super(x, y, facingRight);
        this.species = "raccoon";
        this.leftKey = LEFT;
        this.rightKey = RIGHT;
        this.jumpKey = UP;
        this.actionKey = DOWN;
        super.setSprite();
    }
}