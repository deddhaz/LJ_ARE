drop table PBI_LearningJourneyARE_DataTarget
SELECT 
    de.nik,
    de.Name,
    de.JobTitle,
    de.WorkLocation,
    de.Area,
    de.Region,
	de.Unit,
    de.[Join Date],
    de.EmploymentStatus,
	pg.[Status Kelulusan] as [Status Kelulusan GPOP],
	pg1.[Status Kelulusan] as [Status Kelulusan GLP1],
    ph.[Handle Spv]
 
INTO PBI_LearningJourneyARE_DataTarget
FROM DataEmployeeMbeat de
LEFT JOIN hcir.dbo.pichchandle ph ON ph.Cabang = de.WorkLocation
LEFT JOIN PBI_GPOP_Check pg on pg.NIK = de.nik
left join PBI_GLP1_Cek pg1 on pg1.NIK = de.NIK
Where de.JobTitle in ('ARE (Car Product)', 'ARE (Motorcycle Product)', 'Branch NDF Car Agency Supervisor', 'Branch Non Dealer Financing Motorcycle Spv Agency', 'Branch NDF Multiproduct Agency Supervisor') or de.NIK in ('076201', '5002479', '5002517', '5002530', '5002580')



	
