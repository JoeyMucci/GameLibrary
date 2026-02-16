public class SpikeBlock extends Block implements Interactable {
    public SpikeBlock(int leftBlock, int rightBlock, int topBlock, int bottomBlock) {
        super(leftBlock, rightBlock, topBlock, bottomBlock);
        spriteName = "spikeblock.png";
    }

    public void drawSelf() {
        for(int row = topBlock; row <= bottomBlock; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = leftBlock; col <= rightBlock; col++) {
                int x = col * BLOCK_SIZE;
                image(sprites.get(spriteName).image, x, y);
            }
        }
    }

    // The resolute raccoon can stand on spikes with boots
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(fallingInto(mascot, this)) {
                if(mascot.id != MoverID.RACCOON || !mascot.hasItem(ItemID.BOOTS)) {
                    return InteractCode.HIT;
                }
            }
        }
        return InteractCode.OK;
    }
}