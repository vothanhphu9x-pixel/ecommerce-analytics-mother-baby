# Data Dictionary

## Fact_Sales
| Field             | Data Type     | Description                                 | Constraints                |
|-------------------|--------------|---------------------------------------------|----------------------------|
| ORDER_ID          | INT          | Mã đơn hàng                                 | FK                         |
| CUSTOMER_ID       | INT          | Mã khách hàng                               | FK                         |
| PRODUCT_ID        | INT          | Mã sản phẩm                                 | FK                         |
| CAMPAIGN_ID       | INT          | Mã chiến dịch                               | FK                         |
| CHANNEL           | VARCHAR(20)  | Kênh bán hàng                               | CHECK (WEB/APP/STORE)      |
| REGION            | VARCHAR(50)  | Khu vực bán hàng                            | NOT NULL                   |
| ORDER_DATE        | DATE         | Ngày đặt hàng                               | NOT NULL                   |
| REVENUE           | DECIMAL      | Doanh thu                                   | CHECK (REVENUE > 0)        |
| COGS              | DECIMAL      | Giá vốn                                     | CHECK (REVENUE > 0)        |
| DISCOUNT_AMOUNT   | DECIMAL      | Chiết khấu                                  | DEFAULT = 0                |
| STATUS            | VARCHAR(20)  | Trạng thái                                  | CHECK (COMPLETED/RETURN/CANCEL) |

## FACT_MARKETING
| Field        | Data Type     | Description         | Constraints                |
|--------------|--------------|---------------------|----------------------------|
| CAMPAIGN_ID  | INT          | Mã chiến dịch       | FK                         |
| CHANNEL      | VARCHAR(50)  | Kênh quảng cáo      | CHECK (FB,GOOGLE,...)      |
| IMPRESSION   | INT          | Lượt hiển thị       | CHECK (IMPRESSION > 0)     |
| CLICKS       | INT          | Lượt clicks         | CHECK (CLICKS > 0)         |
| VISIT        | INT          | Lượt truy cập       | CHECK (VISIT > 0)          |
| SPEND        | DECIMAL      | Chi phí             | CHECK (COST > 0)           |

## DIM_CUSTOMER
| Field        | Data Type     | Description         | Constraints                |
|--------------|--------------|---------------------|----------------------------|
| CUSTOMER_ID  | INT          | Mã khách hàng       | PK, NOT NULL               |
| FULL_NAME    | STRING       | Tên khách hàng      | NULL                       |
| GENDER       | CHAR(1)      | Giới tính           | CHECK (MALE/FEMALE)        |
| AGE          | INT          | Tuổi                | CHECK (AGE > 0)            |
| IMCOME       | VARCHAR(50)  | Thu nhập            |                            |

## DIM_CAMPAIGN
| Field         | Data Type      | Description         | Constraints                |
|---------------|---------------|---------------------|----------------------------|
| CAMPAIGN      | INT           | Mã chiến dịch       | PK                         |
| CAMPAIGN_NAME | VARCHAR(100)  | Tên chiến dịch      |                            |
| START_DATE    | DATE          | Ngày bắt đầu        |                            |
| END_DATE      | DATE          | Ngày kết thúc       |                            |
| OBJECTIVE     | VARCHAR(50)   | Mục tiêu            |                            |

## DIM_PRODUCT
| Field        | Data Type     | Description         | Constraints                |
|--------------|--------------|---------------------|----------------------------|
| PRODUCT_ID   | INT          | Mã sản phẩm         | PK                         |
| SKU          | VARCHAR(50)  | Stock Keeping Unit  |                            |
| CATEGORY     | VARCHAR(50)  | Nhóm                |                            |
| BRAND        | VARCHAR(50)  | Thương hiệu         |                            |

## FACT_UX
| Field                  | Data Type     | Description                     | Constraints                |
|------------------------|--------------|---------------------------------|----------------------------|
| UX_ID                  | INT          | Mã UX                           | PK                         |
| ORDER_ID               | INT          | Mã đơn hàng                     | FK                         |
| DELIVERY_TIME          | INT          | Thời gian giao hàng             |                            |
| EXPECTED_DELIVERY_TIME | INT          | Thời gian giao hàng dự kiến     |                            |
| RATING                 | INT          | Mức độ hài lòng KH              | CHECK (1-5)                |
| NPS                    | INT          | Chỉ số sẵn sàng giới thiệu      | CHECK (1-10)               |

---

**PK**: Primary Key  
**FK**: Foreign Key  
**CHECK**: Ràng buộc giá trị  
**DEFAULT**: Giá trị mặc định
