package kr.bit.service;

import java.util.List;

import kr.bit.entity.*;

public interface BoardService {

    public Member login(Member vo);
    public Member registerCheck(String memID);
    public int memRegister(Member m);
    public List<Food> getSearchList(Food food);
    public Image getMyDrug(int id);
    public Food getFoodIngredients(String foodName);
    public Image getImageById(Long id);
    public List<Image> getImageByUserId(String userId);
    public String getFoodIngredientsByDrugName(String drugName);
}
