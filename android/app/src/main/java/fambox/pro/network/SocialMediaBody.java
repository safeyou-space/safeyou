package fambox.pro.network;

public class SocialMediaBody {

    private String name;
    private String socialMediaTitle;
    private String socialMediaLink;
    private String socialMediaIconPath;
    private boolean isHtml;

    public boolean isHtml() {
        return isHtml;
    }

    public void setHtml(boolean html) {
        isHtml = html;
    }

    public String getSocialMediaTitle() {
        return socialMediaTitle;
    }

    public void setSocialMediaTitle(String socialMediaTitle) {
        this.socialMediaTitle = socialMediaTitle;
    }

    public String getSocialMediaLink() {
        return socialMediaLink;
    }

    public void setSocialMediaLink(String socialMediaLink) {
        this.socialMediaLink = socialMediaLink;
    }

    public String getSocialMediaIconPath() {
        return socialMediaIconPath;
    }

    public void setSocialMediaIconPath(String socialMediaIconPath) {
        this.socialMediaIconPath = socialMediaIconPath;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
