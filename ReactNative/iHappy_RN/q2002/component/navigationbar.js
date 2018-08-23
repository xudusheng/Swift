/**
 * Created by zhengda on 16/10/20.
 */

import React from 'react';

import {
    StyleSheet,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';

// import Dimensions from 'Dimensions';
// let {width, height} = Dimensions.get('window');

export default class NavigatiowView extends React.Component {
    static defaultProps = {
        leftView: ()=>{},
        titleView: ()=>{},
        rightView: ()=>{},
    };
    static propTypes = {
        leftView: React.PropTypes.func,
        titleView: React.PropTypes.func,
        rightView: React.PropTypes.func,
    };

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.NavigatorViewStyle}>
                    <View style={styles.leftViewStyle}>
                        {this.props.leftView()}
                    </View>

                    <View style={styles.titleViewStyle}>
                        {this.props.titleView()}
                    </View>

                    <View style={styles.rightViewStyle}>
                        {this.props.rightView()}
                    </View>
                </View>
            </View>

        );
    }
}

const styles = StyleSheet.create({
    container:{
        height: 64,
        backgroundColor: 'rgba(255, 96, 0, 1.0)',
    },
    NavigatorViewStyle: {
        marginTop:20,
        height: 44,
        flexDirection:'row',
        backgroundColor: 'rgba(255, 96, 0, 1.0)',
    },

    leftViewStyle: {
        flex: 1,
        marginLeft:10,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'flex-start',

    },
    titleViewStyle: {
        flex: 3,
        justifyContent:'center',
        alignItems:'center',
    },
    rightViewStyle: {
        flex: 1,
        marginRight:10,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'flex-end',
    },
});
