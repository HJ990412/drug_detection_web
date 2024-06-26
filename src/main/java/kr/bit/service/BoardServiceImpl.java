package kr.bit.service;

import java.util.List;

import kr.bit.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.bit.mapper.BoardMapper;

@Service
public class BoardServiceImpl implements BoardService{

    @Autowired
    BoardMapper boardMapper;

    @Override
    public Member login(Member vo) {
        Member mvo=boardMapper.login(vo);

        return mvo;
    }

    @Override
    public Image getMyDrug(int id) {

        Image image=boardMapper.getMyDrug(id);

        return image;
    }

    @Override
    public Food getFoodIngredients(String foodName) {
        return boardMapper.getFoodIngredients(foodName);
    }

    @Override
    public Image getImageById(Long id) {
        return boardMapper.findById(id);
    }

    @Override
    public List<Image> getImageByUserId(String userId) {
        return boardMapper.findByUserId(userId);
    }

    @Override
    public String getFoodIngredientsByDrugName(String drugName) {
        return boardMapper.getFoodIngredientsByDrugName(drugName);
    }


    @Override
    public List<Food> getSearchList(Food food) {
        return boardMapper.selectSearchList(food);
    }

    @Override
    public Member registerCheck(String memID) {
        return boardMapper.registerCheck(memID);
    }

    @Override
    public int memRegister(Member m) {
        return boardMapper.memRegister(m);
    }



}
