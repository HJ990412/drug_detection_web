package kr.bit.entity;

import lombok.Data;

@Data
public class Image {
    private Long id;
    private String userId;
    private String message;
    private String image;
}
