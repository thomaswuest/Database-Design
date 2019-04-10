
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[UPDATE_MEMBER_BALANCE]   
	ON  [dbo].[DETAILRENTAL]
   AFTER UPDATE
AS 
BEGIN
	declare @rent_num int
	declare @Fee_After decimal
	declare @Prior_Fee decimal 

--update data
	if(exists (select * from deleted) and exists (select * from inserted))
	begin
		declare update_cursor cursor for
		select	r.rent_num, sum((d.detail_duedate - d.detail_returndate) * d.detail_dailylatefee) as Proir_Fee,
		sum((r.detail_duedate - r.detail_returndate) * r.detail_dailylatefee) as Fee_After
		from deleted d inner join r on d.Rent_Num = r.rent_num 
		group by r.rent_num 

		open	update_cursor
		fetch	next from update_cursor
				into @rent_num, @Fee_After, @Prior_Fee
		while	(@@FETCH_STATUS = 0)

	begin
		if (@Fee_After is null)
		begin
			set @Prior_Fee = 0
		end 

		if(@Fee_After is null )
		begin
			set @Fee_After = 0
		end

	begin
			update	MEMBERSHIP
			set		Mem_Balance = Mem_Balance + (@Prior_Fee - @Fee_After)
			from	MEMBERSHIP m inner join RENTAL r on m.Mem_Balance = r.Mem_Num 
					inner join DETAILRENTAL d on r.Rent_Num = d.Rent_Num 
			where	r.Rent_Num = @rent_num
			fetch	next from update_cursor
					into @rent_Num, @prior_fee, @fee_after
	end
	end
	close update_cursor 
	deallocate update_cursor 
end
end


SET NOCOUNT ON;

    -- Insert statements for trigger here



