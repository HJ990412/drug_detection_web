package kr.bit.entity;

import lombok.Data;

import java.util.List;

@Data
public class Member {

    private int memIdx;
    private String memID;
    private String memPwd;
    private String memName;
    private List<AuthVO> authList;
}