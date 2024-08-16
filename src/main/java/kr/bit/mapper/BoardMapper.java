package kr.bit.mapper;

import java.util.List;

import kr.bit.entity.*;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {
    public Member login(Member vo);
    public Member registerCheck(String memID);
    public int memRegister(Member m);
    public List<Food> selectSearchList(Food food);
    public Image getMyDrug(int id);
    public Food getFoodIngredients(String foodName);
    public Image findById(Long id);
    public List<Image> findByUserId(String userId);
    public String getFoodIngredientsByDrugName(String drugName);
    public Member findByMemID(String username);
    public void authInsert(AuthVO saveVO);
    public List<Member> getAllMembers();
    public void deleteMember(String memID);
    public void deleteMemberAuth(String memID);
    public void deleteMemberDrugList(String memID);

}