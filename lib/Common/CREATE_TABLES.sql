create table restaurant (`id` integer primary key, menusharingcode varchar(20), restaurantname varchar(50), address text, contact varchar(20), lat varchar(20), lang varchar(20), landmark varchar(50), city varchar(20), state varchar(30), minimumorderamount varchar(5), minimumdeliverytime varchar(30), deliverycharge varchar(5), packaging_charge varchar(15), packaging_charge_type varchar(20));
create table ordertype (`id` integer primary key, ordertypeid varchar(3), ordertype varchar(15));
create table `category` (`id` integer primary key, categoryid varchar(6), `active` varchar(2), categoryrank varchar(2), parent_category_id varchar(2), categoryname varchar(30), categorytimings varchar(50), category_image_url text);

