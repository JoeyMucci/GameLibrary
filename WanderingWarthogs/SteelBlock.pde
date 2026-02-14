public class SteelBlock extends Block implements Interactable {
    public final float MAGNET_BUFFER = BLOCK_SIZE / 2;

    public SteelBlock(int blockLeft, int blockRight, int blockTop, int blockBottom) {
        super(blockLeft, blockRight, blockTop, blockBottom);
    }

    public void drawSelf() {
        fill(ORANGE);
        for(int row = blockTop; row <= blockBottom; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = blockLeft; col <= blockRight; col++) {
                int x = col * BLOCK_SIZE;
                rect(x, y, BLOCK_SIZE, BLOCK_SIZE);
            }
        }
    }

    // The resolute raccoon can stick to the bottom of steel blocks with magnet equipped
    public void interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(mascot.id == MoverID.RACCOON && mascot.hasItem(ItemID.MAGNET)) {
                if(jumpingInto(mascot, this, MAGNET_BUFFER)) {
                    mascot.setTopY(getBottomRight().y);
                    mascot.magnetize();
                }
            }
        }
    }
}