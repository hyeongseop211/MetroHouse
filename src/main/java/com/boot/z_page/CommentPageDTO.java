package com.boot.z_page;

import com.boot.z_page.criteria.CriteriaDTO;

import lombok.Data;

@Data
public class CommentPageDTO {
   private int startPage;
   private int endPage;
   private boolean prev, next;
   private int total;
   private CriteriaDTO criteriaDTO;

   public CommentPageDTO(int total, CriteriaDTO criteriaDTO) {
      this.total = total;
      this.criteriaDTO = criteriaDTO;

      // 댓글 페이지 번호를 사용
      this.endPage = (int) (Math.ceil(criteriaDTO.getCommentPageNum() / 10.0)) * 10;
      this.startPage = this.endPage - 9;

      int realEnd = (int) (Math.ceil((total * 1.0) / criteriaDTO.getAmount()));

      if (realEnd <= this.endPage) {
         this.endPage = realEnd;
      }

      this.prev = this.startPage > 1;
      this.next = this.endPage < realEnd;
   }
}