public class SteelBlock extends Block implements Interactable {
    public final float MAGNET_BUFFER = BLOCK_SIZE / 2;

    public SteelBlock(int leftBlock, int rightBlock, int topBlock, int bottomBlock) {
        super(leftBlock, rightBlock, topBlock, bottomBlock);
    }

    public void drawSelf() {
        fill(ORANGE);
        for(int row = topBlock; row <= bottomBlock; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = leftBlock; col <= rightBlock; col++) {
                int x = col * BLOCK_SIZE;
                rect(x, y, BLOCK_SIZE, BLOCK_SIZE);
            }
        }
    }

    // The resolute raccoon can stick to the bottom of steel blocks with magnet equipped
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(mascot.id == MoverID.RACCOON && mascot.hasItem(ItemID.MAGNET)) {
                if(jumpingInto(mascot, this, MAGNET_BUFFER)) {
                    mascot.setTopY(getBottomRight().y);
                    mascot.magnetize();
                }
            }
        }
        return InteractCode.OK;
    }
}