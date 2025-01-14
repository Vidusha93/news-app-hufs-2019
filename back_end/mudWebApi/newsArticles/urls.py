from django.urls import path, include
from .views import index, Summary, RegisterdUsers, NewsCluster, FavoriteList, RatingList, RecommendList, AllUserFavoriteList
from rest_framework import routers

router = routers.DefaultRouter()
router.register("articles", Summary)
router.register("users", RegisterdUsers)
router.register("clusters", NewsCluster)
router.register("bookmarks", FavoriteList)
router.register("rating", RatingList)
router.register("recommend", RecommendList)
router.register("allbookmarks", AllUserFavoriteList)

urlpatterns = [
    path('', index, name="index"),
    path('', include(router.urls)),
]