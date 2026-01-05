local Room = {}
Room.__index = Room

type Object = {
	CreatorID : number,
	RoomID : number,
	Name : string,
	Description : string,
	RoomIcon : string,
	Online : boolean,
	Players : number,
	Favorites : number,
	MaxPlayers : number,
	Visits : number,
	InQueue : number,
	CreationDate : string,
	Genres : {string},
	Map : number,
	SettingsLayoutID : number,
	Status : string,
	Permissions : {string : {string}}
}

export type RoomClass = Object

return Room