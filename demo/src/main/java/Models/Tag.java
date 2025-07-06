package Models;

public class Tag {
    private long tagId;
    private String tagName;

    public Tag() {}

    public Tag(long tagId, String tagName) {
        this.tagId = tagId;
        this.tagName = tagName;
    }

    public long getTagId() {
        return tagId;
    }

    public void setTagId(long tagId) {
        this.tagId = tagId;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}
