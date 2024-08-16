package kr.bit.security;

import kr.bit.entity.Member;
import kr.bit.entity.MemberUser;
import kr.bit.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemberUserDetailsService implements UserDetailsService {

    private final BoardService boardService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        Member mvo = boardService.findByMemID(username);
        if(mvo != null) {
            return new MemberUser(mvo); //Member, AuthVO
        }else {
            throw new UsernameNotFoundException("user with username"+username+"dose not exist.");
        }
    }
}
