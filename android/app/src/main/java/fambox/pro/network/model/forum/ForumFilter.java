package fambox.pro.network.model.forum;

import lombok.Data;

@Data
public class ForumFilter {
    private int id;
    private String name;
    private int type;

    public ForumFilter(int id, String name, int type) {
        this.id = id;
        this.name = name;
        this.type = type;
    }
}
