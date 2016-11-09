/**
 * Created by zhengda on 16/10/31.
 */

import * as TYPES from '../actions/types';
import * as GlobleConst from '../pages/p.const';

const initialState = {
    isRefreshing: false,//是否下拉刷新
    loading: false,//是否正在加载
    isLoadMore: false,//是否是上拉加载更多
    movieList: {},//元素：{dataBlob:{}, sectionIDs:[], rowIDs:[], nextPage:1, loadAll:true}
};

export default function movie(state = initialState, action) {
    switch (action.type) {
        case TYPES.FETCH_DOING:
            return {
                ...state,
                isRefreshing: action.isRefreshing,
                loading: true,
                isLoadMore: action.isLoadMore,
            };

        case TYPES.FETCH_DONE:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                movieList: action.isLoadMore ? loadMore(state, action) : combine(state, action),
            };

        case TYPES.FETCH_ERROE:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                isLoadMore: false,
            };
        case TYPES.CLEAR_SEARCH_RESULT: {
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                isLoadMore: false,
                movieList: clearSearchResult(state),
            }
        }
        default:
            return state;
    }
};

function loadMore(state, action) {
    var movieData = state.movieList[action.typeId];
    var dataBlob = movieData.dataBlob;
    let sectionIDs = movieData.sectionIDs;
    let rowIDs = movieData.rowIDs;
    let currentPage = movieData.nextPage;

    if (sectionIDs.length == 1) {//只有单组时才有下拉刷新功能，这里的数据结构有待优化，太不好处理了

        let new_dataBlob = action.movieList.dataBlob;
        let new_sectionIDs = action.movieList.sectionIDs;
        let new_rowIDs = action.movieList.rowIDs[0];

        let sectionnum = sectionIDs[0];
        var singleSection_RowIDs = rowIDs[0];
        let rowsCount = singleSection_RowIDs.length;
        for (var i = 0; i < new_rowIDs.length; i++) {
            let index = i;
            let new_rowData = new_dataBlob[sectionnum + ':' + index];
            dataBlob[sectionnum + ':' + (rowsCount + index)] = new_rowData;
            singleSection_RowIDs.push(rowsCount + index);
        }

        var nextPage = currentPage;
        var loadAll = false;
        if (new_rowIDs.length >= 15) {
            nextPage += 1;
        } else {
            loadAll = true;
        }
        let new_movieList = {
            dataBlob: dataBlob,
            sectionIDs: sectionIDs,
            rowIDs: [singleSection_RowIDs],
            nextPage: nextPage,
            loadAll: loadAll,
        };
        state.movieList[action.typeId] = new_movieList;
    }
    return state.movieList;
}

function combine(state, action) {
    var movieList = action.movieList;
    movieList.nextPage = 2;

    let sectionIDs = action.movieList.sectionIDs;
    var loadAll = false;
    if (sectionIDs.length == 1) {//只有单组时才有下拉刷新功能，这里的数据结构有待优化，太不好处理了
        let new_rowIDs = action.movieList.rowIDs[0];
        if (new_rowIDs.length < 15) {
            loadAll = true;
        }
    }

    movieList.loadAll = loadAll;
    state.movieList[action.typeId] = movieList;
    return state.movieList;
}

function clearSearchResult(state) {
    state.movieList[GlobleConst.SearchTypeId] = undefined;
    return state.movieList;
}