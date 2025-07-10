package com.boot.z_util.otherMVC.dao;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UtilDAO {
	public int getAllApartmentCount();
//	public int getAvgPrice();
	public Integer getAvgPrice();
}
