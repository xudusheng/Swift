/**
 * Created by zhengda on 16/10/20.
 */

import React, {Component} from 'react';

import {
    StyleSheet,
    View,
    Image,
    Text,
    TouchableOpacity,
} from 'react-native';

export default class QMovieDetailInfoView extends Component {
    static defaultProps = {
        imageurl: '',
        title: '',
        infoList: [],
    };
    static propTypes = {
        imageurl: React.PropTypes.string.isRequired,
        title: React.PropTypes.string.isRequired,
        infoList: React.PropTypes.array.isRequired,
    };

    render() {
        return (
            <View style={styles.container}>
                <Image source={{url: this.props.imageurl}} style={styles.movieImageStyle}/>

                <View style={styles.movieInfoContainerView}>
                    {this.createItems()}

                </View>
            </View>
        );
    }

    //创建详情item
    createItems() {
        console.log('---------------------');
        console.log(this.props.infoList);
        var itemList = [];
        for (var i = 0; i < this.props.infoList.length; i++) {
            let itemIndex = i;
            let itemInfo = this.props.infoList[itemIndex];
            let item =
                <View key={itemIndex} style={styles.oneInfoItemStyle}>
                    <Text style={styles.itemTextStyle} numberOfLines={1}>
                        {itemInfo.title + '：' + itemInfo.content}
                    </Text>
                </View>
            itemList.push(item);
        }
        return itemList;
    }
}

const styles = StyleSheet.create({
    container: {
        height: 130,
        flexDirection: 'row',
    },

    movieImageStyle: {
        width: 90,
    },

    movieInfoContainerView: {
        flex: 1,
    },

    oneInfoItemStyle: {
        flex: 1,
        justifyContent:'center',
    },

    itemTextStyle: {
        fontSize: 11,
        color: '#666666',
        marginLeft:5,
        marginRight:5,
    },
});
