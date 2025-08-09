const mangaListResponse = {
  "result": "ok",
  "response": "collection",
  "data": [
    {
      "id": "manga-id-1",
      "type": "manga",
      "attributes": {
        "title": {"en": "Test Manga"},
        "altTitles": [],
        "description": {"en": "Description"},
        "isLocked": false,
        "originalLanguage": "ja",
        "status": "ongoing",
        "contentRating": "safe",
        "chapterNumbersResetOnNewVolume": false,
        "tags": [],
        "state": "published",
        "version": 1,
        "createdAt": "2020-01-01T00:00:00.000Z",
        "updatedAt": "2021-01-01T00:00:00.000Z"
      },
      "relationships": []
    }
  ],
  "limit": 1,
  "offset": 0,
  "total": 1
};

const mangaDetailResponse = {
  "result": "ok",
  "response": "entity",
  "data": {
    "id": "a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6",
    "type": "manga",
    "attributes": {
      "title": {"en": "Test Manga"},
      "altTitles": [],
      "description": {"en": "Description"},
      "isLocked": false,
      "originalLanguage": "ja",
      "status": "ongoing",
      "contentRating": "safe",
      "chapterNumbersResetOnNewVolume": false,
      "tags": [],
      "state": "published",
      "version": 1,
      "createdAt": "2020-01-01T00:00:00.000Z",
      "updatedAt": "2021-01-01T00:00:00.000Z"
    },
    "relationships": []
  }
};

const chapterListResponse = {
  "result": "ok",
  "response": "collection",
  "data": [
    {
      "id": "chapter-id-1",
      "type": "chapter",
      "attributes": {
        "title": "Chapter 1",
        "volume": "1",
        "chapter": "1",
        "pages": 10,
        "translatedLanguage": "en",
        "version": 1,
        "createdAt": "2021-01-01T00:00:00.000Z",
        "updatedAt": "2021-01-01T00:00:00.000Z",
        "publishAt": "2021-01-01T00:00:00.000Z",
        "readableAt": "2021-01-01T00:00:00.000Z"
      },
      "relationships": []
    }
  ],
  "limit": 100,
  "offset": 0,
  "total": 1
};

const coverArtResponse = {
  "result": "ok",
  "response": "collection",
  "data": [
    {
      "id": "cover-id-1",
      "type": "cover_art",
      "attributes": {
        "fileName": "cover.jpg",
        "description": "Main cover",
        "volume": "1",
        "locale": "en",
        "version": 1,
        "createdAt": "2021-05-24T17:03:00.000Z",
        "updatedAt": "2021-05-24T17:03:00.000Z"
      },
      "relationships": []
    }
  ],
  "limit": 1,
  "offset": 0,
  "total": 1
};

const atHomeServerResponse = {
  "result": "ok",
  "baseUrl": "https://example.com",
  "chapter": {
    "hash": "some-hash",
    "data": ["page1.jpg"],
    "dataSaver": ["page1.jpg.saver"]
  }
};

const tagListResponse = {
  "result": "ok",
  "response": "collection",
  "data": [
    {
      "id": "tag-id-1",
      "type": "tag",
      "attributes": {
        "name": {"en": "Action"},
        "description": {},
        "group": "genre",
        "version": 1
      },
      "relationships": []
    }
  ],
  "limit": 1,
  "offset": 0,
  "total": 1
};