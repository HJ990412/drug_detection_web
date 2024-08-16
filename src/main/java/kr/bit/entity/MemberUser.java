package kr.bit.entity;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.stream.Collectors;

@Getter
@Setter
public class MemberUser extends User {

    private Member member;

    public MemberUser(Member mvo) {
        super(mvo.getMemID(), mvo.getMemPwd(),
                mvo.getAuthList().stream()
                        .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
                        .collect(Collectors.toList()));
        this.member = mvo;
        // List<AuthVO> -> Collection<SimpleGrantedAuthority>
    }

    public String getMemID() {
        return member.getMemID();
    }

    public Member getMember() {
        return member;
    }
}
